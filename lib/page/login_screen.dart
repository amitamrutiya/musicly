import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicly/components/big_text.dart';
import 'package:musicly/constant/app_colors.dart';
import 'package:musicly/constant/dimensions.dart';
import 'package:musicly/constant/image_string.dart';
import 'package:musicly/controller/auth_controller.dart';
import 'package:musicly/page/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController =
      Get.put<AuthController>(AuthController());
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  backgroundColor: AppColors.primaryDarkColor),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: BigText(
                text: "Something Went Wrong",
                size: 30,
              ),
            );
          }
          if (snapshot.hasData) {
            return HomeScreen(title: "Hi, ${snapshot.data!.displayName} 👋");
          } else {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(255, 18, 18, 36),
                    Color.fromARGB(255, 103, 103, 187),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.height30 * 2),
                      Center(
                        child: Image(
                            image: const AssetImage(
                                ImageString.login_screen_image),
                            height: Dimensions.screenHeight * 0.3),
                      ),
                      SizedBox(height: Dimensions.height45),
                      SizedBox(height: Dimensions.height10),
                      BigText(
                        text: "Login",
                        size: Dimensions.font20 * 2,
                        color: Colors.white,
                      ),
                      SizedBox(height: Dimensions.height10),
                      BigText(
                        text: "Login with Your Google Account",
                        size: Dimensions.font20,
                        color: Colors.white70,
                      ),
                      SizedBox(height: Dimensions.height30),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30))),
                          icon: const Image(
                              image: AssetImage(ImageString.google_logo_image),
                              width: 20.0),
                          onPressed: () async {
                            await authController.googleLogin(context).then((_) {
                              if (authController.hasError!.value) {
                                Get.closeAllSnackbars();
                                Get.snackbar("Answer",
                                    authController.errorCode!.value.toString(),
                                    icon: Icon(
                                      Icons.dangerous_rounded,
                                      size: Dimensions.iconSize16 * 2,
                                    ),
                                    titleText: Text(
                                      "Answer",
                                      style: TextStyle(
                                          fontSize: Dimensions.font20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              'assets/fonts/SourceSansPro-Bold'),
                                    ),
                                    messageText: Text(
                                      "Please Selecte Any One Option",
                                      style: TextStyle(
                                          fontSize: Dimensions.font16),
                                    ),
                                    backgroundColor: Colors.red,
                                    backgroundGradient: const LinearGradient(
                                        colors: [
                                          Color(0xffED6F9E),
                                          Color(0xffEC8B6A)
                                        ]));
                              }
                            });
                          },
                          label: const Text(
                            "Log In With Google",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Get.off(
                                  () => const HomeScreen(
                                        title: "Welcom to Musicly",
                                      ),
                                  transition: Transition.fadeIn);
                            },
                            child: const Text(
                              "Continue Without Sign In",
                              style: TextStyle(color: Colors.white70),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
