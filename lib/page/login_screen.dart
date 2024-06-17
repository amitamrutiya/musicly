import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topRight,
          colors: [Color.fromARGB(255, 18, 18, 36), Color.fromARGB(255, 103, 103, 187)],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/login_screen.png'),
                  ),
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Login with Your Google Account",
                    style: TextStyle(     color: Colors.white70, fontSize: 15)),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    icon: const Image(
                        image: AssetImage('assets/images/google_logo.png'),
                        width: 20.0),
                    onPressed: () async {},
                    label: const Text(
                      "Log In With Google",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Continue Without Sign In",
                        style: TextStyle(color: Colors.white70),
                      )),
                )
              ],
            ),
          ))),
    );
  }
}
