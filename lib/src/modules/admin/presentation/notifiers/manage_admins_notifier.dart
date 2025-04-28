import 'package:jima/src/core/error_handling/try_catch.dart';
import 'package:jima/src/modules/admin/data/admin_source.dart';
import 'package:jima/src/modules/profile/domain/entities/user.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

typedef ManageAdminsState = BaseState<List<User>>;

class ManageAdminsNotifier extends BaseNotifier<List<User>> {
  final AdminSource _source;

  ManageAdminsNotifier(this._source) : super(const InitialState(data: []));

  Future<void> fetchAdmins() async {
    setInLoading();

    final result = await _source.fetchAdmins().tryCatch();

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right(:final value) => setSuccess(value..sort()),
    };
  }

  Future<void> addAdmin(String email) async {
    setOutLoading();

    final result = await _source.switchUsersToAdmin(email).tryCatch();
    print('result: $result');

    return switch (result) {
      Left(:final value) => setError(value.displayMessage),
      Right() => () {
          setSuccess(data);
          fetchAdmins();
        }(),
    };
  }

  Future<void> removeUserAsAdmin(User user) async {
    setOutLoading(data: data!.copyRemove(user));

    final result = await _source.removeUserAsAdmin(user.id).tryCatch();

    return switch (result) {
      Left(:final value) => setError(
          value.displayMessage,
          data!.copyAdd(user)..sort(),
        ),
      Right() => () {
          setSuccess(data);
          fetchAdmins();
        }(),
    };
  }
}
