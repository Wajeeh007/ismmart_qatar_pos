import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDownList1 extends StatelessWidget {
  final String? title;
  final bool asterisk;
  final RxString value;
  final ValueChanged? onChanged;
  final List<String> list;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final String? labelText;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;

  const CustomDropDownList1({
    super.key,
    this.title,
    required this.value,
    required this.onChanged,
    required this.list,
    this.asterisk = false,
    this.validator,
    this.autoValidateMode,
    this.labelText,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 13.5,
    ),
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title == null)
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 1),
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      (asterisk)
                          ? const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            )
                          : const TextSpan(text: '')
                    ],
                  ),
                ),
              ),
    DropdownButtonFormField(
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: contentPadding,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: fillColor ?? Colors.white.withOpacity(0.1),
            ),
            dropdownColor: const Color(0xFF526D82),
            autovalidateMode: autoValidateMode,
            validator: validator,
            iconSize: 20,
            value: value.value,
            isExpanded: true,
            onChanged: onChanged,
            items: list.map(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
      ],
    );
  }
}
