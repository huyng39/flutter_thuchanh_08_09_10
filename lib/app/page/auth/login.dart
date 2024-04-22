import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'register.dart';
import 'package:flutter_thuchanh_08/mainpage.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';

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
  String errorText = '';

  login() async {
    //lấy token (lưu share_preference)
    try{
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
    saveUser(user,token);
    //
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const Mainpage()));
    return token;
    }
    catch (error){
      setState(() {
        isLoading = false;
      });

       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đăng nhập không thành công!\n Vui lòng kiểm tra lại.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            padding: const EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0,top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        urlLogo,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      ),
                      const Text(
                        "THÔNG TIN ĐĂNG NHẬP",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: accountController,
                        validator: RequiredValidator(
                            errorText: 'Please enter Account'),
                        decoration: const InputDecoration(
                          labelText: "Account",
                          icon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        textInputAction: TextInputAction.go,
                        validator: RequiredValidator(
                            errorText: 'Please Enter Password'),
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
                                // login();

                                //thông báo lỗi nếu ko tìm thấy user
                                String response = await login();
                                if (response == token) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Mainpage()));
                                  setState(
                                    () => isLoading = false,
                                  );
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          title: Text("Alert"),
                                          content: SingleChildScrollView(
                                            child: Text(
                                                "Please check your information again!"),
                                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
