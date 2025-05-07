import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

final class AppStorageService {
  final SupabaseClient _client;

  AppStorageService({
    required SupabaseClient client,
  }) : _client = client;

  /// Uploads a file at a local [filePath] to the supabase storage [bucket]
  Future<String> uploadFile(
    String filePath, {
    required String bucket,
    int? retryAttempts,
  }) async {
    final refId = DateTime.now().millisecondsSinceEpoch;
    final file = File(filePath);
    final filename = filePath.split('/').last;

    final path =
        '$filename-$refId'.trim().replaceAll('..', '').replaceAll('~', '');

    await _client.storage
        .from(bucket)
        .upload(path, file, retryAttempts: retryAttempts);

    final String downloadUrl =
        '${_client.storage.url}/object/public/$bucket/$path';

    return downloadUrl;
  }

  /// Uploads a file at a local [filePath] to the supabase storage [bucket]
  Future<String> uploadFileBinary(
    Uint8List file,
    String filename, {
    required String bucket,
    int? retryAttempts,
  }) async {
    final refId = DateTime.now().millisecondsSinceEpoch;
    final path =
        '$filename-$refId'.trim().replaceAll('..', '').replaceAll('~', '');

    await _client.storage
        .from(bucket)
        .uploadBinary(path, file, retryAttempts: retryAttempts);

    final String downloadUrl =
        '${_client.storage.url}/object/public/$bucket/$path';

    return downloadUrl;
  }

  /// Deletes the specified urls from the specified storage bucket
  ///
  /// Note that all the files in that url must be from the same bucket
  Future<void> delete(
    List<String> urls, {
    required String bucket,
  }) async {
    final leading = '${_client.storage.url}/object/public/$bucket/';

    final paths = urls.map((url) {
      return url.replaceAll(leading, '');
    }).toList();

    await _client.storage.from(bucket).remove(paths);
  }
}
