import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DateTimeTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onPressed;
  const DateTimeTextField(
      {required this.controller,
      required this.icon,
      required this.hint,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  State<DateTimeTextField> createState() => _DateTimeTextFieldState();
}

class _DateTimeTextFieldState extends State<DateTimeTextField> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      padding: const EdgeInsets.all(6),
      color: Colors.grey.shade600,
      child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a ${widget.hint}';
            }
            return null;
          },
          controller: widget.controller,
          readOnly: true,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          widget.controller.clear();
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.grey))
                  : null,
              prefixIcon: IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(widget.icon, color: Colors.black, size: 30)),
              hintStyle: const TextStyle(color: Colors.grey),
              hintText: widget.hint,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none)),
    );
  }
}
