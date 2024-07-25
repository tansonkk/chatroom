import 'package:chatroom/components/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/components/MyDialog.dart';
import 'package:chatroom/api.dart';
import 'package:flutter/services.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({super.key});

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  final emailController = TextEditingController();
  final optController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void initState() {
    super.initState();
    emailController.text = '';
    optController.text = '';
    newPasswordController.text = '';
    confirmPasswordController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    optController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> getOPT(String email) async {
    if (email.isEmpty) {
      Dialogs.showAlert(context, "please enter a valid email");
    } else {
      await APIS().sendOTP(email);
      Dialogs.showAlert(context, "OPT send to $email, please check");
    }
  }

  Future<void> resetPassword(String email, String opt, String newPassword,
      String confirmPassword) async {
    final bool success =
        await APIS().resetPassword(email, opt, newPassword, confirmPassword);
    if (success) {
      Dialogs.showAlert(context, "Password reset successful")
          .then((value) => Navigator.pushNamed(context, '/home'));
    } else {
      Dialogs.showAlert(context, "Password reset failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
              child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.password,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Forget password page',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: emailController,
                          obscureText: false,
                          validator: (value) {
                            final text = emailController.text;
                            const pattern =
                                r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                            final regex = RegExp(pattern);
                            if (text.isNotEmpty &&
                                !regex.hasMatch(emailController.text)) {
                              return 'Enter a valid email address';
                            }

                            if (text.isEmpty) {
                              return 'Please enter a value';
                            }
                            if (text.length > 50) {
                              return 'email length max is  50 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: "email",
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                    ),
                    MyButton(
                        onTap: () => getOPT(emailController.text),
                        content: "get OPT"),
                  ],
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: optController,
                    obscureText: false,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return "must entry opt";
                      }
                      if ((value ?? '').length != 4) {
                        return "must be 4 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "opt",
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: newPasswordController,
                    obscureText: _isNewPasswordObscure,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return "Please enter a password";
                      }
                      if ((value ?? '').length < 8) {
                        return "password length at lest is 8 characters";
                      }
                      if (value != confirmPasswordController.text) {
                        return "must be same as confirm password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: "new pw",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[500],
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordObscure = !_isNewPasswordObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _isConfirmPasswordObscure,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return "Please enter a password";
                      }
                      if ((value ?? '').length < 8) {
                        return "password length at lest is 8 characters";
                      }
                      if (value != newPasswordController.text) {
                        return "must be same as new password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: "confirm pw",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[500],
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordObscure =
                                !_isConfirmPasswordObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      resetPassword(
                          emailController.text,
                          optController.text,
                          newPasswordController.text,
                          confirmPasswordController.text);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          )),
        ));
  }
}
