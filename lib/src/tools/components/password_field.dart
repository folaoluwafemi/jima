import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/tools_barrel.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.passwordToMatch,
    this.validate = true,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextEditingController? passwordToMatch;
  final bool validate;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  final _visibility = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _visibility.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.labelText,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            height: 1.3,
            color: AppColors.black500,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.boxHeight,
        ValueListenableBuilder<bool>(
          valueListenable: _visibility,
          builder: (context, value, child) {
            return TextFormField(
              controller: widget.controller,
              validator: widget.validate
                  ? (value) {
                      if (widget.passwordToMatch == null) {
                        return value.validatePassword();
                      } else if (widget.passwordToMatch?.text != value) {
                        return 'Passwords do not match';
                      } else {
                        return value.validatePassword();
                      }
                    }
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: value,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: widget.hintText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: 8.circularBorder,
                  borderSide: const BorderSide(color: AppColors.iGrey500),
                ),
                suffixIcon: IconButton(
                  icon: value
                      ? Vectors.eye.vectorAssetWidget(dimension: 24.sp)
                      : Vectors.crossedEye.vectorAssetWidget(dimension: 24.sp),
                  onPressed: () {
                    _visibility.value = !_visibility.value;
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 9.5,
                  horizontal: 8,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
