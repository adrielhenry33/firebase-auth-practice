import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String dica;
  final bool isObscured ;

  const TextFieldComponent({
    super.key,
    required this.controller,
    required this.dica,
    required this.isObscured
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: controller,
            obscureText: isObscured,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: dica,
            ),
          ),
        ),
      ),
    );
  }
}
