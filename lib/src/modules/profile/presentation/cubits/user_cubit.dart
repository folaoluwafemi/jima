import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/modules/profile/data/profile_source.dart';
import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vanilla_state/vanilla_state.dart';

class UserNotifier extends BaseNotifier<User?> {
  StreamSubscription? sub;
  final ProfileDataSource _source;

  UserNotifier(this._source)
      : super(
          InitialState(data: container<SupabaseAuthService>().currentState),
        ) {
    sub = container<SupabaseAuthService>()
        .changes
        .listen(userSubscriptionListener);
  }

  void userSubscriptionListener(AuthState? user) {
    setInitial(user?.session?.user);
  }

  Future<void> updateUserProfileImage() async {
    if (state.isOutLoading) return;
    final file = await FilePicker.platform.pickFiles(type: FileType.image);
    if ((file?.paths).isNullOrEmpty || state.isOutLoading) return;
    setOutLoading();
    final result =
        await _source.updateProfilePicture(file!.paths.first!).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => () {
          setSuccess(
            (data
              ?..userMetadata?.update(
                'profile_photo',
                (_) => value,
              )),
          );
          notifyListeners();
        }(),
    };
  }

  String? get firstname => data?.userMetadata?['firstname'];

  String? get profilePicture => data?.userMetadata?['profile_photo'];

  String? get lastname => data?.userMetadata?['lastname'];
}
