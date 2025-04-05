import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/signup_notifier.dart';
import 'package:jima/src/tools/components/app_text_field.dart';
import 'package:jima/src/tools/components/password_field.dart';
import 'package:jima/src/tools/components/primary_button.dart';
import 'package:jima/src/tools/components/vanilla_consumer.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:vanilla_state/vanilla_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => SignupNotifier(container()),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            13.boxHeight,
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Sign Up',
                style: Textstyles.bold.copyWith(
                  color: AppColors.textBlack,
                  fontSize: 32,
                ),
              ),
            ),
            42.boxHeight,
            Form(
              key: formKey,
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField.text(
                            labelText: 'First Name',
                            hintText: 'Enter your first name',
                            textCapitalization: TextCapitalization.words,
                            controller: firstnameController,
                          ),
                        ),
                        12.boxWidth,
                        Expanded(
                          child: AppTextField.text(
                            labelText: 'Last Name',
                            hintText: 'Enter your last name',
                            textCapitalization: TextCapitalization.words,
                            controller: lastnameController,
                          ),
                        ),
                      ],
                    ),
                    12.boxHeight,
                    AppTextField.email(
                      labelText: 'Email Address',
                      controller: emailController,
                    ),
                    12.boxHeight,
                    PasswordTextField(
                      labelText: 'Password',
                      controller: passwordController,
                    ),
                    12.boxHeight,
                    ListenableBuilder(
                      listenable: passwordController,
                      builder: (context, _) {
                        return PasswordTextField(
                          labelText: 'Confirm Password',
                          controller: confirmPasswordController,
                          hintText: 'Enter your password again',
                          validator: (value) {
                            if (value.isNullOrEmpty) return 'Field is required';
                            if (value == passwordController.text) return null;
                            return 'Passwords do not match';
                          },
                        );
                      },
                    ),
                    32.boxHeight,
                    VanillaListener<SignupNotifier, SignupState>(
                      listener: (previous, current) => handleErrorCase(
                        previous,
                        current,
                        context: context,
                        callback: (previous, current) {
                          if (current.isSuccess) {
                            context.goNamed(AppRoute.dashboard.name);
                          }
                        },
                      ),
                      child: VanillaBuilder<SignupNotifier, SignupState>(
                        builder: (context, state) {
                          return AppButton.primary(
                            loading: state.isOutLoading,
                            onPressed: () {
                              final validated =
                                  formKey.currentState?.validate();
                              if (validated != true) return;
                              context.hideKeyboard();
                              context.read<SignupNotifier>().signup(
                                    firstname: firstnameController.text.trim(),
                                    lastname: lastnameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  );
                            },
                            text: 'Sign Up',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
