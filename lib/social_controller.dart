import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flocdock/services/dio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'View/Screens/AllowLocation/allow_location.dart';
import 'View/Screens/Home/home_page.dart';
import 'View/base/custom_snackbar.dart';
import 'View/base/loading_dialog.dart';
import 'View/loading_dialog.dart';
import 'mixin/data.dart';
import 'models/user_model/signup_model.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Profile profile=Profile();

  final Rx<User?> _firebaseUser = Rx<User?>(null);

  User? get user => _firebaseUser.value;

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  Future<void> signInWithApple(BuildContext context) async {
    showLoadingDialog();
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        showConsole(user);
        showConsole(userCredential.additionalUserInfo!.profile);
        final msg = jsonEncode({
          "request_type": "apple_login",
          "name": user.displayName,
          "email": user.email,
          "accessToken": credential.accessToken,
          "userId": user.uid,
        });

        print(user.toString());
        openLoadingDialog(context, "Loading");
        var response;
        response = await DioService.post('signup_with_social', {
          "userName":user.displayName,
          "userEmail":user.email,
          "accountType":"apple_login",
          "userType":"1",
          "googleAccessToken" : user.uid,
          "oneSignalId": "1234"
        });
        print(response);
        if(response['status']=='success / Signed in with Apple'){
          var jsonData= response['data'];
          UserDetail userDetail   =  UserDetail.fromJson(jsonData);
          AppData().userdetail =userDetail;
          print(AppData().userdetail!.toJson());
          Navigator.pop(context);
          showCustomSnackBar(response['status'],isError: false);
          Get.to(() => AllowLocation());
        }
        else{
          Navigator.pop(context);
          print(response['message']);
          showCustomSnackBar(response['message']);
        }




        // await registerUserApi(msg);
      } else {
        dismissLoadingDialog();
        showConsole("user");
        showCustomSnackBar1("Login Failed", "Something went Wrong");
      }
    } on FirebaseAuthException catch (error) {
      dismissLoadingDialog();
      showConsole('Login Failed ${error.message}');
      showCustomSnackBar1("Login Failed", error.message.toString());
    }
  }


  void showCustomSnackBar1(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.actionTextColor,
    );

    // Get.showSnackbar(GetSnackBar(
    //   backgroundColor: isError ? Colors.red : Colors.green,
    //   message: message.isNull?" ":message.isEmpty?" ":message,
    //   maxWidth: Dimensions.WEB_MAX_WIDTH,
    //   duration: Duration(seconds: 3),
    //   snackStyle: SnackStyle.FLOATING,
    //   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    //   borderRadius: Dimensions.RADIUS_SMALL,
    //   isDismissible: true,
    //   dismissDirection: DismissDirection.horizontal,
    // ));
  }

  void showConsole(text) {
    if (kDebugMode) {
      print(text);
    }
  }
}