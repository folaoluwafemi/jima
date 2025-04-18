import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/core/supabase_infra/storage_service.dart';
import 'package:jima/src/tools/constants/buckets.dart';

class ProfileDataSource {
  final SupabaseAuthService _authService;
  final AppStorageService _storageService;

  ProfileDataSource(this._authService, this._storageService);

  Future<String> updateProfilePicture(String path) async {
    final downloadUrl = await _uploadProfilePicture(path);

    await _authService.updateUserInfo(
      data: {
        ...?_authService.currentState?.userMetadata,
        'profile_photo': downloadUrl,
      },
    );
    return downloadUrl;
  }

  Future<String> _uploadProfilePicture(String path) async {
    final userImage = _authService.currentState!.userMetadata?['profile_photo'];

    if (userImage != null) {
      await _storageService.delete(
        [userImage],
        bucket: StorageBuckets.profilePhoto,
      );
    }
    final downloadUrl = await _storageService.uploadFile(
      path,
      bucket: StorageBuckets.profilePhoto,
    );
    return downloadUrl;
  }
}
