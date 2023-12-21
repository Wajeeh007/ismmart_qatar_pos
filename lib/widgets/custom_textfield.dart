import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField1 extends StatelessWidget {
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final AutovalidateMode? autoValidateMode;
  final bool asterisk;
  final bool? showCursor;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Color? fillColor;
  final IconData suffixIcon;
  final IconData? prefixIcon;
  final double prefixIconSize;
  final double suffixIconSize;
  final EdgeInsetsGeometry contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? suffixOnPressed;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField1({
    super.key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    this.asterisk = false,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.autoValidateMode,
    this.title,
    this.hint,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.onTap,
    this.minLines,
    this.showCursor,
    required this.suffixIcon,
    this.prefixIconSize = 18,
    this.suffixIconSize = 18,
    this.fillColor,
    this.prefixIcon,
    this.errorText,
    this.readOnly = false,
    this.inputFormatters,
    this.suffixOnPressed,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title == null)
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black,
                    ),
                    children: [
                      (asterisk)
                          ? const TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Color(0xffD60A0A),
                                fontSize: 12,
                              ),
                            )
                          : const TextSpan(text: '')
                    ],
                  ),
                ),
              ),
        TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          showCursor: showCursor,
          readOnly: readOnly,
          autovalidateMode: autoValidateMode,
          obscureText: obscureText,
          validator: validator,
          onTap: onTap,
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            errorMaxLines: 2,
            suffixIcon: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: suffixOnPressed,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  suffixIcon,
                  size: 22,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
            suffixIconConstraints: BoxConstraints.tight(const Size(60, 40)),
            contentPadding: contentPadding,
            fillColor: fillColor ?? Colors.white.withOpacity(0.1),
            filled: true,
            hintText: hint ?? 'Search here...',
            isDense: true,
            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
