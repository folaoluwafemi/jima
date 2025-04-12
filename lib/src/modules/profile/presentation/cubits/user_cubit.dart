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
          InitialState(
            data: container<SupabaseAuthService>().currentState,
          ),
        ) {
    sub = container<SupabaseAuthService>()
        .changes
        .listen(userSubscriptionListener);
  }

  void userSubscriptionListener(AuthState? user) {
    setData(user?.session?.user);
  }

  Future<void> updateUserProfileImage() async {
    final file = await FilePicker.platform.pickFiles(type: FileType.image);
    if ((file?.paths).isNullOrEmpty) return;
    setOutLoading();
    final result =
        await _source.uploadProfilePicture(file!.paths.first!).tryCatch();


  }

  String? get firstname => data?.userMetadata?['firstname'];

  String? get lastname => data?.userMetadata?['lastname'];
}
