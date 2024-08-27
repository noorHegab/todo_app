import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/components.dart';
import 'package:todo/layout/initial_screen.dart';
import 'package:todo/models/user_model.dart';
import 'package:todo/service/firebase_functions.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserCredential? userCredential;
  UserModel? user;
  bool isSecure = true;

  void changeSecure() {
    isSecure = !isSecure;
    notifyListeners();
  }

  Future<void> createAccount(BuildContext context) async {
    String email = emailController.text.trim();
    try {
      UserCredential credential = await FireBaseFunctions.createAccount(
        email,
        passwordController.text,
        nameController.text,
        phoneController.text,
      );

      if (credential.user != null) {
        navigateAndFinish(context, LayoutScreen());
      }
    } catch (e) {
      notifyListeners();
      _showSnackBar(context, 'Error', "Failed to create account: $e",
          ContentType.failure);
    }
  }

  Future<void> login(BuildContext context) async {
    try {
      String email = emailController.text.trim();
      userCredential = await FireBaseFunctions.login(
        email,
        passwordController.text,
      );

      if (userCredential?.user != null) {
        user = await FireBaseFunctions.getUser();
        navigateAndFinish(context, LayoutScreen());
        _showSnackBar(context, 'Welcome', "Welcome back ${user!.name}",
            ContentType.success);
      }
    } catch (e) {
      _showSnackBar(context, 'Oh no!', "Email or Password is incorrect",
          ContentType.failure);
    }

    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String title, String message,
      ContentType contentType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      );
    });
  }
}
