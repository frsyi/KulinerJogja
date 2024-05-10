import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  const FormWidget(
      {super.key,
      required this.formKey,
      required this.etEmail,
      required this.etPassword});

  final GlobalKey<FormState> formKey;
  final TextEditingController etEmail;
  final TextEditingController etPassword;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: widget.etEmail,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Masukkan Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                bool valid = RegExp(r"@").hasMatch(value!);
                if (value.isEmpty) {
                  return "Masukkan email dengan benar";
                } else if (!valid) {
                  return "Harus ada @";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: widget.etPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Masukkan Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Masukkan password dengan benar";
                } else if (value.length < 6) {
                  return "Masukkan minimal 6 characters";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ));
  }
}
