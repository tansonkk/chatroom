import 'package:chatroom/api.dart';
import 'package:chatroom/components/MyDialog.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/components/TextField.dart';
import 'package:chatroom/components/MyButton.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void signUserUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password do not match!"),
        ),
      );
      return;
    }

    try {
      bool result =
          await APIS().register(emailController.text, passwordController.text);
      if (result) {
        Dialogs.showAlert(context, "register successful")
            .then((value) => Navigator.pushNamed(context, '/home'));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),

                //Text
                Text(
                  'Create a new account',
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

                const SizedBox(height: 25),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'confirm password',
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
                  onTap: signUserUp,
                  content: "Register",
                ),
                //or continue with

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
