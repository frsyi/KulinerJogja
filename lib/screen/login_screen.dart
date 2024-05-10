import 'package:flutter/material.dart';
import 'package:kuliner_jogja/screen/home_screen.dart';
import 'package:kuliner_jogja/widget/footer_widget.dart';
import 'package:kuliner_jogja/widget/form_widget.dart';
import 'package:kuliner_jogja/widget/header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var email = TextEditingController();
    var password = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const HeaderWidget(),
                const SizedBox(
                  height: 30,
                ),
                FormWidget(
                  etEmail: email,
                  etPassword: password,
                  formKey: formKey,
                ),
                FooterWidget(
                  onPressedLogin: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Login Berhasil"),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
