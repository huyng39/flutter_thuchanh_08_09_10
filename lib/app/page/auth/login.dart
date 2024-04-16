import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import '../register.dart';
import 'package:flutter_thuchanh_08/mainpage.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_thuchanh_08/loading.dart';
import 'package:loading_btn/loading_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  login() async {
    //lấy token (lưu share_preference)
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    setState(() {
      isLoading = true;
    });
    // tải hiệu ứng chờ loading
    Future.delayed(const Duration(seconds: 20), () {
      setState(() {
        isLoading = false;
      });
    });
    const LoadAnimation();
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: isLoading
          ? const Center(
              child: LoadAnimation(),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
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
                              RequiredValidator(errorText: 'Please Enter'),
                          decoration: const InputDecoration(
                            labelText: "Account",
                            icon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          textInputAction: TextInputAction.go,
                          validator:
                              RequiredValidator(errorText: 'Please Enter'),
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
                              onPressed: login,
                              child: const Text("Login"),
                            )),
                            // LoadingBtn(
                            //   height: 40, 
                            //   width: 220,
                            //   borderRadius: 25,
                            //   animate: true,
                            //   child: Text("Login",style: TextStyle(color: Colors.white),),
                            //   color: Colors.blue,
                            //   loader: Container(
                            //     padding: const EdgeInsets.all(10),
                            //     width: 40,
                            //     height: 40,
                            //     child: const CircularProgressIndicator(color: Colors.white,),
                            //   ),
                            //   onTap: login(),
                            //   ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Register()));
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
    );
  }
}
