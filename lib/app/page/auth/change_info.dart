import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Thêm thư viện này để sử dụng Clipboard
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/model/user/user.dart';
import 'package:flutter_thuchanh_08/app/route/changepassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeInfo extends StatefulWidget {
  const ChangeInfo({Key? key}) : super(key: key);

  @override
  State<ChangeInfo> createState() => _DetailState();
}

class _DetailState extends State<ChangeInfo> {
  late User user;
  bool isEditing = true;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();
  TextEditingController schoolYearController = TextEditingController();
  TextEditingController schoolKeyController = TextEditingController();
  TextEditingController imageURLController =
      TextEditingController(); // Thêm controller cho URL hình ảnh

  Future<void> getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null) {
      setState(() {
        user = User.fromJson(jsonDecode(strUser));
        fullNameController.text = user.fullName!;
        phoneNumberController.text = user.phoneNumber!;
        genderController.text = user.gender!;
        birthDayController.text = user.birthDay!;
        schoolYearController.text = user.schoolYear!;
        schoolKeyController.text = user.schoolKey!;
        imageURLController.text =
            user.imageURL ?? ''; // Set giá trị cho URL hình ảnh
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void toggleEdit() {
    if (isEditing == false) {
      // Thực hiện cập nhật dữ liệu
      // print('Cập nhật thông tin');
      print('Đã cập nhật thông tin');
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  void pasteImageURL() async {
    // Lấy dữ liệu từ clipboard và gán vào TextEditingController
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    print('Thong tin hinh: ${clipboardData!.text}');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        imageURLController.text = clipboardData.text!;
      });
    }
  }

  void clearImageURL() {
    setState(() {
      imageURLController.text = user.imageURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sửa thông tin',
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        iconTheme: iconBackColor,
        backgroundColor: appBarBackgroundColor,
        // actions: [
        //   IconButton(
        //     onPressed: toggleEdit,
        //     icon: Icon(isEditing ? Icons.save : Icons.edit),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 260.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: user != null &&
                          user.imageURL != null &&
                          user.imageURL.isNotEmpty
                      ? Image.network(
                          imageURLController.text,
                          fit: BoxFit.contain,
                        )
                      : Center(
                          child: Text(
                            'Chọn hình ảnh từ album hoặc dán đường link ảnh vào đây',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
                if (isEditing)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.paste),
                      onPressed: pasteImageURL,
                      tooltip: 'Dán đường link ảnh',
                    ),
                  ),
                if (isEditing)
                  Positioned(
                    top: 30,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.clear_rounded),
                      onPressed: clearImageURL,
                      tooltip: 'Xóa hình ảnh',
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: 'Fullname',
                border: OutlineInputBorder(),
                enabled: isEditing,
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                enabled: isEditing,
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
                enabled: isEditing,
                prefixIcon: Icon(Icons.people),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: birthDayController,
              decoration: InputDecoration(
                labelText: 'Birth Day',
                border: OutlineInputBorder(),
                enabled: isEditing,
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: schoolYearController,
              decoration: InputDecoration(
                labelText: 'School Year',
                border: OutlineInputBorder(),
                enabled: isEditing,
                prefixIcon: Icon(Icons.school),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: schoolKeyController,
              decoration: InputDecoration(
                labelText: 'School Key',
                border: OutlineInputBorder(),
                enabled: isEditing,
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            SizedBox(height: 20.0),
            if (isEditing)
              TextFormField(
                controller: imageURLController,
                decoration: InputDecoration(
                  labelText: 'URL hình ảnh',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
              ),
            SizedBox(height: 10.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () {
                toggleEdit();
                // AwesomeDialog(
                //   context: context,
                //   dialogType: DialogType.success,
                //   animType: AnimType.scale,
                //   title: 'Lưu thành công',
                //   btnOkOnPress: () {},
                //   headerAnimationLoop: false,
                //   btnOkText: "OK",
                // ).show();
              },
              child: isEditing
                  ? Text(
                      'Lưu',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Sửa thông tin',
                      style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1)),
                    ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                elevation: MaterialStateProperty.all<double>(5.0),
              ),
              onPressed: () {
                // TODO: Implement password change functionality
                Navigator.push(
                  // Điều hướng sang màn hình đổi mật khẩu
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePassword(),
                  ),
                );
              },
              child: Text(
                'Đổi mật khẩu',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
