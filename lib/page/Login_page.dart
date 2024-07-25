import 'package:chatroom/api.dart';
import 'package:chatroom/components/MyDialog.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/components/MyButton.dart';
import 'package:chatroom/components/TextField.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("email is empty"),
        ),
      );
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("password is empty"),
        ),
      );
    }

    try {
      final result =
          await APIS().login(emailController.text, passwordController.text);

      if (result) {
        Navigator.pushNamed(context, '/chatlist');
      } else {
        Dialogs.showAlert(context, "email or password is wrong");
      }
    } catch (e) {
      debugPrint("error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),

                Text(
                  'Login page',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                //username textfield
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),

                //password textfield
                const SizedBox(height: 25),
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obscureText: true,
                ),
                //forget password?
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onTap: () =>
                            Navigator.pushNamed(context, '/forgotpassword'),
                      )
                    ],
                  ),
                ),

                //sign in button
                const SizedBox(height: 10),
                MyButton(
                  onTap: signIn,
                  content: "Sign in",
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
