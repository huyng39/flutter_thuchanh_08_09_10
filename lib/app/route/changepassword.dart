import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:flutter_thuchanh_08/app/model/user/register.dart';
import 'package:flutter_thuchanh_08/app/page/auth/login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> changePass() async {
    bool check = await APIRepository()
        .changePassword(_oldPasswordController.text, _passwordController.text);
    if (check) {
      print('Cập nhật mật khẩu thành công');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Cập nhật mật khẩu thành công',
        btnOkOnPress: () {},
        headerAnimationLoop: false,
        btnOkText: "OK",
      ).show();
      setState(
        () => isLoading = false,
      );
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Đã xảy ra lỗi',
        desc: 'Vui lòng kiểm tra lại mật khẩu hiện tại',
        btnOkOnPress: () {},
        headerAnimationLoop: false,
        btnOkText: "OK",
        btnOkColor: Colors.red,
      ).show();
      setState(
        () => isLoading = false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đổi mật khẩu",
          style: titleStyle,
        ),
        backgroundColor: appBarBackgroundColor,
        iconTheme: iconBackColor,
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
                      controller: _oldPasswordController,
                      validator: RequiredValidator(
                          errorText: 'Vui lòng nhập mật khẩu hiện tại'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu hiện tại",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: RequiredValidator(
                          errorText: 'Vui lòng nhập mật khẩu mới'),
                      // onFieldSubmitted: (value) => login,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Mật khẩu mới",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.go,
                      validator: RequiredValidator(
                          errorText: 'Vui lòng nhập lại mật khẩu'),
                      // onFieldSubmitted: (value) => login,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Nhập lại mật khẩu",
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
                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.scale,
                                  title: 'Mật khẩu không trùng khớp',
                                  desc:
                                      'Vui lòng kiểm tra lại mật khẩu mới\nvà nhập lại mật khẩu',
                                  btnOkOnPress: () {},
                                  headerAnimationLoop: false,
                                  btnOkText: "OK",
                                  btnOkColor: Colors.blue,
                                ).show();
                                setState(
                                  () => isLoading = false,
                                );
                              } else {
                                if (isLoading) return;
                                setState(
                                  () => isLoading = true,
                                );
                                changePass();
                              }
                            }
                          },
                          child: isLoading
                              ? LoadingAnimationWidget.waveDots(
                                  color: Colors.white, size: 35)
                              : const Text(
                                  "Lưu",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
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
