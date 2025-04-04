import 'package:jima/src/core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {
  final SupabaseClient client = Supabase.instance.client;

  static SupabaseApi get instance => container<SupabaseApi>();

  /// [url] and [anonKey] are to be passed in from env
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}
