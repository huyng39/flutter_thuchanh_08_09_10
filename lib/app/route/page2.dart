import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:flutter_thuchanh_08/app/model/register.dart';
import 'package:flutter_thuchanh_08/app/page/auth/login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Future<String> changePass() async {
  //   return await APIRepository().register(Ch(
  //       accountID: _accountController.text,
  //       birthDay: _birthDayController.text,
  //       password: _passwordController.text,
  //       confirmPassword: _confirmPasswordController.text,
  //       fullName: _fullNameController.text,
  //       phoneNumber: _phoneNumberController.text,
  //       schoolKey: _schoolKeyController.text,
  //       schoolYear: _schoolYearController.text,
  //       gender: getGender(),
  //       imageUrl: _imageURL.text,
  //       numberID: _numberIDController.text));
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change password"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _passwordController,
                      validator:
                          RequiredValidator(errorText: 'Please enter Password'),
                      decoration: const InputDecoration(
                        labelText: "Password",
                        icon: Icon(Icons.password),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.go,
                      validator:
                          RequiredValidator(errorText: 'Please Enter Confirm Password'),
                      // onFieldSubmitted: (value) => login,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
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
                              // String response = await login();
                              // if (response == token) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const Mainpage()));
                              //   setState(
                              //     () => isLoading = false,
                              //   );
                              // } 
                              // else {
                              //   showDialog(
                              //       context: context,
                              //       builder: (BuildContext context) {
                              //         return const AlertDialog(
                              //           title: Text("Alert"),
                              //           content: SingleChildScrollView(
                              //             child: Text(
                              //                 "Please check your information again!"),
                              //           ),
                              //         );
                              //       });
                              //   setState(
                              //     () => isLoading = false,
                              //   );
                              // }
                            }
                          },
                          child: isLoading
                              ? LoadingAnimationWidget.waveDots(
                                  color: Colors.white, size: 35)
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        )),
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
