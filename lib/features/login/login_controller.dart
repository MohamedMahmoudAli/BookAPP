import 'package:book_app/core/constants/storage_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GetStorage instance to store UID
  final box = GetStorage();

  void login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save UID to GetStorage
      final uid = userCredential.user?.uid;
      if (uid != null) {
        box.write('uid', uid);
        print("UID saved: $uid");
      }
      GetStorage().write(StorageKeys.isLoggedIn, true);


      Get.offAllNamed('/home');

    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';

      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided';
      }

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Retrieve UID
  String? getUserId() {
    return box.read('uid');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void goToForgotPassword() {
    Get.snackbar(
      'Info',
      'Forgot Password screen not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
