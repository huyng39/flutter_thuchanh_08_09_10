import 'dart:async';

import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import '../register.dart';
import 'package:flutter_thuchanh_08/mainpage.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_thuchanh_08/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool idEmpty = false;
  bool passEmpty = false;
  final _formKey = GlobalKey<FormState>();
  var response;
  String token = '';

  login() async {
    //lấy token (lưu share_preference)
    token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    setState(() {
      isLoading = true;
    });

    // tải hiệu ứng chờ loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    // save share
    saveUser(user);
    //
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Login"),
      // ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      urlLogo,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                    ),
                    const Text(
                      "LOGIN INFORMATION",
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: accountController,
                      validator:
                          RequiredValidator(errorText: 'Please enter Account'),
                      decoration: const InputDecoration(
                        labelText: "Account",
                        icon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.go,
                      validator:
                          RequiredValidator(errorText: 'Please Enter Password'),
                      onFieldSubmitted: (value) => login,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        icon: Icon(Icons.password),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {

                            //kiểm tra nếu pass hết validator
                            if (_formKey.currentState!.validate()) {
                              if (isLoading) return;
                              setState(
                                () => isLoading = true,
                              );
                              login();

                              //thông báo lỗi nếu ko tìm thấy user
                              String token = await login();
                              if (token == '401' || token == '500') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      title: Text("Alert"),
                                      content: Text(
                                          "Please check your information again!"),
                                    );
                                  });
                                  setState(
                                () => isLoading = false,
                              );
                            }
                            }

                            
                          },
                          child: isLoading
                              ? LoadingAnimationWidget.waveDots(
                                  color: Colors.white, size: 35)
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        )),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text("Register"),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
