import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/core/supabase_infra/database.dart';
import 'package:jima/src/core/supabase_infra/storage_service.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/tools/constants/buckets.dart';
import 'package:jima/src/tools/constants/tables.dart';

class ProfileDataSource {
  final SupabaseAuthService _authService;
  final AppDatabaseService _databaseService;
  final AppStorageService _storageService;

  ProfileDataSource(
    this._authService,
    this._storageService,
    this._databaseService,
  );

  Future<User> updateProfilePicture(
    String path, {
    String? oldUrl,
  }) async {
    final downloadUrl = await _uploadProfilePicture(path, oldUrl);

    final id = _authService.currentState!.id;

    final value = await _databaseService.update(
      Tables.users,
      values: {'profilePhoto': downloadUrl},
      filter: (request) => request.eq('id', id),
      transform: (request) => request.maybeSingle(),
    );

    return User.fromMap(value);
  }

  Future<String> _uploadProfilePicture(String path, String? oldUrl) async {
    if (oldUrl != null) {
      await _storageService.delete(
        [oldUrl],
        bucket: StorageBuckets.profilePhoto,
      );
    }
    final downloadUrl = await _storageService.uploadFile(
      path,
      bucket: StorageBuckets.profilePhoto,
    );
    return downloadUrl;
  }

  Future<User> fetchUser() async {
    final id = _authService.currentState?.id;
    if (id == null) throw 'User not authenticated';

    final value = await _databaseService.selectSingle(
      Tables.users,
      filter: (request) => request.eq('id', id),
    );

    return User.fromMap(value);
  }
}
