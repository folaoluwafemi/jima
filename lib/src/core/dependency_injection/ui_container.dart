import 'package:jima/src/modules/auth/presentation/notifiers/login_notifier.dart';
import 'package:flutter/material.dart';
import 'package:vanilla_state/vanilla_state.dart';

class GeneralUiIOCContainer extends StatelessWidget {
  final Widget child;

  const GeneralUiIOCContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiInheritedVanilla(
      children: [
        InheritedVanilla(createNotifier: () => LoginNotifier()),
      ],
      child: child,
    );
  }
}
