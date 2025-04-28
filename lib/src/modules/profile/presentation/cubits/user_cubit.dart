import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/profile/data/profile_source.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/modules/profile/domain/entities/user_privilege.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:vanilla_state/vanilla_state.dart';

class UserNotifier extends BaseNotifier<User?> {
  final ProfileDataSource _source;

  UserNotifier(this._source) : super(const InitialState());

  Future<void> updateUserProfileImage() async {
    if (state.isOutLoading) return;
    final file = await FilePicker.platform.pickFiles(type: FileType.image);
    if ((file?.paths).isNullOrEmpty || state.isOutLoading) return;

    setOutLoading();

    final result = await _source
        .updateProfilePicture(file!.paths.first!, oldUrl: data?.profilePhoto)
        .tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => () {
          setSuccess(value);
          notifyListeners();
        }(),
    };
  }

  UserPrivilege get userPrivilege => data?.privilege ?? UserPrivilege.none;

  Future<void> fetchUser() async {
    setInLoading();

    final result = await _source.fetchUser().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => () {
          setSuccess(value);
          notifyListeners();
        }(),
    };
  }
}
