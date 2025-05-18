import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js";

console.log("Hello from Functions!");

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, // Required for deleting
);

interface WebhookPayload {
  type: "DELETE";
  table: string;
  record: GenericMedia | null;
  schema: "public";
  old_record: GenericMedia | null;
}

interface GenericMedia {
  id: string;
  url: string;
  thumbnailUrl: string | null;
}

Deno.serve(async (req) => {
  try {
    const payload: WebhookPayload = await req.json();
    const record = payload.record ?? payload.old_record;
    if (record == null) {
      return new Response("No record found", { status: 400 });
    }
    const { thumbnailUrl } = record;

    if (thumbnailUrl == null) {
      return new Response(JSON.stringify({ success: true }), { status: 200 });
    }

    const thumbnailBucket = "audios";
    const thumbnailPart = thumbnailUrl.replace(
      /^.*object\/public\/${thumbnailBucket}\//,
      "",
    );
    await supabase.storage.from(thumbnailBucket).remove([thumbnailPart]);

    return new Response(JSON.stringify({ success: true }), { status: 200 });
  } catch (e) {
    console.error("Book thumbnail cleanup failed:", e);
    return new Response(JSON.stringify({ success: false, error: e.message }), {
      status: 500,
    });
  }
});
