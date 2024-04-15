import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import '../register.dart';
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

  login() async {
    //lấy token (lưu share_preference)
    String token = await APIRepository()
        .login(accountController.text, passwordController.text);
    var user = await APIRepository().current(token);
    // tải hiệu ứng chờ loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    // save share
    saveUser(user);
    //
    setState(() {
      isLoading = true;
    });
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
      body: isLoading ? LoadingAnimationWidget.discreteCircle(color: Colors.blue,size: 40)
      :SingleChildScrollView(
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
                    validator: RequiredValidator(errorText: 'Please Enter'),
                    decoration: const InputDecoration(
                      labelText: "Account",
                      icon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.go,
                    validator: RequiredValidator(errorText: 'Please Enter'),
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
    );
  }
}
