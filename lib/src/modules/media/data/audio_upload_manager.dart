import 'dart:async';
import 'dart:io';

import 'package:files_uploader/files_uploader.dart';
import 'package:jima/src/modules/media/data/models/upload_event.dart';
import 'package:jima/src/tools/constants/buckets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AudioUploadManager {
  static final _uploader = FlutterUploader();
  static const _uuid = Uuid();

  static final _uploadStreamController =
      StreamController<UploadEvent>.broadcast();

  static Stream<UploadEvent> get uploadStream => _uploadStreamController.stream;

  static Future<void> init() async {
    _uploader.progress.listen((event) {
      _uploadStreamController.add(
        UploadEvent(
          taskId: event.taskId,
          status: UploadStatus.progress,
          progress: event.progress,
        ),
      );
    });

    _uploader.result.listen((event) {
      if (event.status == UploadTaskStatus.complete) {
        _uploadStreamController.add(
          UploadEvent(
            taskId: event.taskId,
            status: UploadStatus.success,
          ),
        );
      } else {
        _uploadStreamController.add(
          UploadEvent(
            taskId: event.taskId,
            status: UploadStatus.failure,
            error: event.response,
          ),
        );
      }
    });
  }

  static Future<void> queueUpload(File file) async {
    final fileName = "${_uuid.v4()}_${file.uri.pathSegments.last}";
    final signedUrl = await getSignedUploadUrl(file.path);
    if (signedUrl == null) return;

    final task = RawUpload(
      tag: fileName,
      path: file.path,
      url: signedUrl,
      method: UploadMethod.PUT,
      headers: {'Content-Type': 'audio/mpeg'},
    );

    _uploadStreamController.add(
      UploadEvent(
        taskId: fileName,
        status: UploadStatus.started,
      ),
    );

    await _uploader.enqueue(task);
  }

  static Future<String?> getSignedUploadUrl(String path) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.storage
        .from(StorageBuckets.audio)
        .createSignedUploadUrl(path);

    return response.signedUrl;
  }
}
