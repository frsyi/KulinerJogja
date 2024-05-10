import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  FooterWidget({super.key, required this.onPressedLogin});

  final VoidCallback onPressedLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(onPressed: onPressedLogin, child: const Text("Login")),
      ],
    );
  }
}
