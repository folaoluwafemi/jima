import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/auth/data/auth_source.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/modules/profile/presentation/cubits/user_cubit.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef SignupState = BaseState<Object?>;

class SignupNotifier extends BaseNotifier<Object?> {
  final AuthSource _source;

  SignupNotifier(this._source) : super(const InitialState());

  Future<void> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    setOutLoading();

    final createdUser = User.create(
      id: '',
      email: email,
      firstname: firstname,
      lastname: lastname,
    );
    final result =
        await _source.signup(seed: createdUser, password: password).tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.message!),
      Right(:final value) => () {
          setSuccess();
          container<UserNotifier>().setData(value);
        }(),
    };
  }
}
