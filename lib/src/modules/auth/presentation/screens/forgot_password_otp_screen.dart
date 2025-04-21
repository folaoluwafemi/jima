import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/modules/auth/presentation/notifiers/forgot_password_notifier.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:pinput/pinput.dart';
import 'package:vanilla_state/vanilla_state.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedVanilla(
      createNotifier: () => ForgotPasswordNotifier(container()),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              13.boxHeight,
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: Textstyles.bold.copyWith(
                        color: AppColors.textBlack,
                        fontSize: 32,
                      ),
                    ),
                    31.8.boxHeight,
                    Text(
                      'Enter confirmation code',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        color: AppColors.blackVoid,
                        fontSize: 16.sp,
                      ),
                    ),
                    8.boxHeight,
                    Text(
                      'Enter your email address and a reset link\n will be sent to you.\n\n',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF71727A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Pinput(
                        length: 6,
                        controller: otpController,
                        preFilledWidget: const Text('-'),
                        defaultPinTheme: PinTheme(
                          height: 48.sp,
                          width: 48.sp,
                          decoration: BoxDecoration(
                            borderRadius: 12.circularBorder,
                            border: Border.all(
                              color: const Color(0xFFC5C6CC),
                            ),
                          ),
                        ),
                      ),
                      48.boxHeight,
                      VanillaListener<ForgotPasswordNotifier,
                          ForgotPasswordState>(
                        listener: (previous, current) => handleErrorCase(
                          previous,
                          current,
                          context: context,
                          callback: (previous, current) {
                            if (current.isSuccess) {
                              context.goNamed(AppRoute.changePassword.name);
                            }
                          },
                        ),
                        child: VanillaBuilder<ForgotPasswordNotifier,
                            ForgotPasswordState>(
                          builder: (context, state) {
                            return AppButton.primary(
                              loading: state.isOutLoading,
                              onPressed: () {
                                final validated =
                                    formKey.currentState?.validate();
                                if (validated != true) return;
                                context.hideKeyboard();
                                context
                                    .read<ForgotPasswordNotifier>()
                                    .verifyOtp(
                                      otpController.text.trim(),
                                      widget.email,
                                    );
                              },
                              text: 'Reset',
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
      ),
    );
  }
}
