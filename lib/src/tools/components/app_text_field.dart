import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/tools_barrel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<String?>? validator;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final bool expands;
  final bool optional;
  final bool isRequired;
  final bool mustUseValidator;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final ValueSetter<String>? onChanged;
  final ValueSetter<String>? onSubmit;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final Widget? prefix;
  final Widget? suffix;
  final bool addPaddingToSuffixIcon;
  final List<Widget> labels;

  const AppTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.textInputType,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.optional = false,
    this.expands = false,
    this.isRequired = true,
    this.mustUseValidator = false,
    this.onTap,
    this.prefixIcon,
    this.onSubmit,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.fillColor,
    this.borderColor,
    this.initialValue,
    this.borderRadius,
    this.onChanged,
    this.autovalidateMode,
    this.textInputAction,
    this.contentPadding,
    this.prefix,
    this.addPaddingToSuffixIcon = true,
    this.labels = const [],
    this.suffix,
    this.focusNode,
    super.key,
  });

  factory AppTextField.search({
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
  }) =>
      AppTextField(
        controller: controller,
        hintText: 'Search',
        fillColor: AppColors.buttonGrey,
        borderColor: AppColors.buttonGrey,
        borderRadius: 25.circularBorder,
        onChanged: onChanged,
        textInputType: TextInputType.text,
        contentPadding: REdgeInsets.symmetric(horizontal: 27),
        prefixIcon: Vectors.searchIcon.vectorAssetWidget(
          dimension: 17.sp,
        ),
        textInputAction: TextInputAction.search,
      );

  factory AppTextField.email({
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    String? labelText = 'Enter your email address',
    String? hintText,
    AutovalidateMode? autovalidateMode,
    ValueChanged<String>? onSubmit,
    bool isRequired = true,
    bool readOnly = false,
    Color? fillColor,
    Widget? suffixIcon,
  }) =>
      AppTextField(
        controller: controller,
        labelText: labelText,
        focusNode: focusNode,
        onSubmit: onSubmit,
        hintText: hintText ?? 'Enter email address',
        textInputType: TextInputType.emailAddress,
        textInputAction: textInputAction,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.onUnfocus,
        isRequired: isRequired,
        readOnly: readOnly,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        validator: (value) {
          return value == null || !value.isValidEmail ? 'Invalid email' : null;
        },
      );

  factory AppTextField.name({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputAction? textInputAction,
    bool isRequired = true,
  }) =>
      AppTextField(
        controller: controller,
        labelText: labelText,
        hintText: hintText,
        isRequired: isRequired,
        textInputType: TextInputType.name,
        textInputAction: textInputAction,
        textCapitalization: TextCapitalization.words,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value == null || value.isEmpty ? 'Field is required' : null;
        },
      );

  factory AppTextField.amount({
    required TextEditingController controller,
    String? labelText,
    required String hintText,
    bool isRequired = true,
    int decimalDigits = 2,
    AutovalidateMode? autovalidateMode,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) =>
      AppTextField(
        controller: controller,
        labelText: labelText,
        hintText: hintText,
        isRequired: isRequired,
        textInputType: TextInputType.number,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        inputFormatters: [
          // CurrencyTextInputFormatter.currency(
          //   name: '',
          //   decimalDigits: decimalDigits,
          // ),
        ],
        validator: validator ??
            (value) {
              return value == null || value.isEmpty
                  ? 'Field is required'
                  : null;
            },
        prefix: const Text(
          '\$ ',
          style: TextStyle(
            color: AppColors.blackVoid,
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
      );

  factory AppTextField.number({
    TextEditingController? controller,
    required String? labelText,
    required String hintText,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? initialValue,
    int? maxLength,
    int? maxLines,
    bool expands = false,
    bool isRequired = true,
    bool readOnly = false,
    AutovalidateMode? autovalidateMode,
  }) =>
      AppTextField(
        controller: controller,
        labelText: labelText,
        hintText: hintText,
        maxLines: maxLines,
        initialValue: initialValue,
        onChanged: onChanged,
        expands: expands,
        autovalidateMode: autovalidateMode,
        isRequired: isRequired,
        readOnly: readOnly,
        textInputType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        validator: validator ??
            (value) {
              return value == null || value.isEmpty
                  ? 'Field is required'
                  : null;
            },
      );

  factory AppTextField.date({
    required TextEditingController controller,
    VoidCallback? onTap,
    required String labelText,
    String hintText = 'DD/MM/YYYY',
    bool isRequired = true,
    bool isReadOnly = true,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String?>? onValidated,
    AutovalidateMode? autovalidatedMode,
  }) =>
      AppTextField(
        controller: controller,
        labelText: labelText,
        hintText: hintText,
        textInputType: TextInputType.datetime,
        readOnly: isReadOnly,
        onChanged: onChanged,
        isRequired: isRequired,
        autovalidateMode: autovalidatedMode,
        inputFormatters: [
          MaskTextInputFormatter(mask: '##/##/####'),
        ],
        onTap: onTap,
        validator: onValidated ??
            (value) {
              return value == null || value.isEmpty ? 'Date is required' : null;
            },
      );

  factory AppTextField.dob({
    required TextEditingController controller,
    required VoidCallback onTap,
    bool isRequired = true,
  }) =>
      AppTextField(
        controller: controller,
        labelText: 'Date of Birth',
        hintText: 'YYYY-MM-DD',
        textInputType: TextInputType.datetime,
        readOnly: true,
        isRequired: isRequired,
        onTap: onTap,
        validator: (value) {
          return value == null || value.isEmpty
              ? 'Date of birth is required'
              : null;
        },
      );

  factory AppTextField.text({
    required String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
    String? initialValue,
    String? labelText,
    int? maxLines = 1,
    int? minLines = 1,
    Widget? suffixIcon,
    Widget? suffix,
    TextInputAction? textInputAction,
    bool expands = false,
    bool readOnly = false,
    bool isRequired = true,
    bool optional = false,
    AutovalidateMode? autovalidateMode,
    TextCapitalization textCapitalization = TextCapitalization.none,
    FormFieldValidator<String?>? validator,
    Key? key,
  }) =>
      AppTextField(
        key: key,
        controller: controller,
        hintText: hintText,
        labelText: labelText,
        initialValue: initialValue,
        maxLines: maxLines,
        minLines: expands ? null : minLines,
        onTap: onTap,
        expands: expands,
        readOnly: readOnly,
        isRequired: isRequired,
        onChanged: onChanged,
        optional: optional,
        suffixIcon: suffixIcon,
        suffix: suffix,
        textInputAction: textInputAction,
        autovalidateMode: autovalidateMode,
        textCapitalization: textCapitalization,
        validator: validator ??
            (value) {
              return value == null || value.isEmpty
                  ? 'Field is required'
                  : null;
            },
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (labelText != null) ...[
          Row(
            children: [
              Text(
                labelText!,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  height: 1.3,
                  color: AppColors.black500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (labels.isNotEmpty) ...[
                const Spacer(),
                ...labels,
              ],
            ],
          ),
          8.boxHeight,
        ],
        Flexible(
          flex: expands ? 1 : 0,
          child: TextFormField(
            focusNode: focusNode,
            initialValue: initialValue,
            controller: controller,
            validator: ((optional || isRequired == false) && !mustUseValidator)
                ? null
                : validator,
            autovalidateMode: autovalidateMode,
            keyboardType: textInputType,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            onFieldSubmitted: onSubmit,
            readOnly: readOnly,
            textAlignVertical: TextAlignVertical.top,
            onTap: onTap,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            onChanged: onChanged,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
                fontSize: 14.sp,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              fillColor: fillColor,
              filled: fillColor != null,
              prefix: prefix,
              prefixIcon: prefixIcon == null
                  ? null
                  : Padding(
                      padding: REdgeInsets.all(14),
                      child: prefixIcon,
                    ),
              suffixIcon: suffixIcon == null
                  ? null
                  : Padding(
                      padding: addPaddingToSuffixIcon
                          ? const EdgeInsetsDirectional.all(16)
                          : EdgeInsetsDirectional.zero,
                      child: suffixIcon,
                    ),
              suffix: suffix,
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? 8.circularBorder,
                borderSide: BorderSide(
                  color: borderColor ?? AppColors.iGrey500,
                ),
              ),
              contentPadding: contentPadding ??
                  REdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
