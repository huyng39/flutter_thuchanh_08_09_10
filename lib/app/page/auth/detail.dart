import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/page/auth/change_info.dart';
import '../../model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String strUser = '';
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    strUser = pref.getString('user')!;
    await Future.delayed(const Duration(seconds: 2));
    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    // create style
    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    );
    return Center(
      child: strUser.isEmpty
          ? LoadingAnimationWidget.discreteCircle(color: Colors.blue, size: 50)
          : SingleChildScrollView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(user.imageURL!),
                        height: 200,
                        width: 200,
                      ),
                      Text("NumberID: ${user.idNumber}", style: mystyle),
                      Text("Fullname: ${user.fullName}", style: mystyle),
                      Text("Phone Number: ${user.phoneNumber}", style: mystyle),
                      Text("Gender: ${user.gender}", style: mystyle),
                      Text("birthDay: ${user.birthDay}", style: mystyle),
                      Text("schoolYear: ${user.schoolYear}", style: mystyle),
                      Text("schoolKey: ${user.schoolKey}", style: mystyle),
                      Text("dateCreated: ${user.dateCreated}", style: mystyle),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Màu chữ và icon
                          minimumSize:
                              Size(150, 50), // Kích thước tối thiểu của nút
                          padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10), // Padding bên trong nút
                        ),
                        icon: Icon(Icons.edit),
                        label: Text(
                          "Sửa thông tin",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChangeInfo()));
                        },
                      ),
                    ]),
              ),
            ),
    );
  }
}
