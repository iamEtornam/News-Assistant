import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EateryTextField extends StatelessWidget {
  const EateryTextField({
    super.key,
    this.textController,
    this.validator,
    this.label,
    required this.placeholderText,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.suffixIcons,
    this.prefixIcons,
    this.initialText,
    this.onChanged,
    this.maxLines,
    this.labelFontWeight,
    this.onSubmitted,
    this.inputFormatters,
    this.isPassword = false,
  });

  final TextEditingController? textController;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSubmitted;
  final String? label;
  final String placeholderText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool enabled;
  final Widget? suffixIcons;
  final Widget? prefixIcons;
  final String? initialText;
  final FontWeight? labelFontWeight;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...{
          Text(
             label!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 15, fontWeight: labelFontWeight ?? FontWeight.w400),
          ),
          const SizedBox(
            height: 8,
          ),
        },
        TextFormField(
          obscureText: isPassword,
          controller: textController,
          keyboardType: keyboardType,
          initialValue: initialText,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          enabled: enabled,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              label: Text(placeholderText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      )),
              alignLabelWithHint: true,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              contentPadding: const EdgeInsets.all(15.0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder:
                  Theme.of(context).inputDecorationTheme.focusedBorder,
              enabledBorder:
                  Theme.of(context).inputDecorationTheme.enabledBorder,
              disabledBorder:
                  Theme.of(context).inputDecorationTheme.disabledBorder,
              errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
              focusedErrorBorder:
                  Theme.of(context).inputDecorationTheme.focusedErrorBorder,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
              errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
              suffixIcon: suffixIcons,
              prefixIcon: prefixIcons),
          cursorColor: Theme.of(context).colorScheme.secondary,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
