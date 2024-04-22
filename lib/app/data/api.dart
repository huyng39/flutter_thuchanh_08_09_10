import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/data/sharepre.dart';
import 'package:flutter_thuchanh_08/app/model/product/product.dart';
import 'package:flutter_thuchanh_08/app/model/user/register.dart';
import 'package:flutter_thuchanh_08/app/model/user/user.dart';
import 'package:flutter_thuchanh_08/app/model/order.dart';

import 'package:dio/dio.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository with ChangeNotifier {
  API api = API();

  int _statusCode = 0;

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else if (res.statusCode == 401) {
        print("Error data");
        return "Error data";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        print("ok login");
        return tokenData;
      } else {
        return "login fail";
      }
    }

    // hiển thị status code
    on DioException catch (e) {
      if (e.response != null) {
        // If the request was made and the server responded with a status code
        print('Error response status code: ${e.response!.statusCode}');
        return 'Error response status code';
      } else {
        // If something went wrong when sending the request
        print("Connection Error");
        return "Connection Error";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  // Lấy danh sách product
  Future<List<Product>> getProduct(int? categoryID) async {
    try {
      User user =
          await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm

      String token = await getToken();
      var path = categoryID == null
          ? '/Product/getList?accountID=${user.accountId}'
          : '/Product/getListByCatId?categoryID=${categoryID}&accountID=${user.accountId}';

      var pathAll = '/Product/getListAdmin';

      var path2 = '/Product/getList?accountID=${user.accountId}';
      // Xây dựng URL với các tham số query
      // var uri = categoryID == null
      //     ? Uri.parse(path)
      //         .replace(queryParameters: {'accountID': user.accountId})
      //     : Uri.parse(path).replace(
      //         queryParameters: {
      //           'categoryID': categoryID,
      //           'accountID': user.accountId
      //         },
      //       );

      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .get(path2.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return List<Product>.from(
            res.data.map((item) => Product.fromJson(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load products: ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

// Thêm danh sách hóa đơn
  Future<bool> addBill(List<Product> lstPro) async {
    try {
      var path = '/Order/addBill';
      // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      // Xây dựng URL với các tham số query
      // Chuyển đổi danh sách sản phẩm thành chuỗi JSON
      List<Map<String, dynamic>> productList = lstPro
          .map(
              (product) => {"productID": product.id, "count": product.quantity})
          .toList();
      // Gửi yêu cầu API
      Response res = await api.sendRequest.post(
        path,
        data: jsonEncode(productList),
        options: Options(headers: header(token)),
      );
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return true;
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Lấy danh sách hóa đơn
  Future<List<OrderModel>> getBill() async {
    try {
      var path = '/Bill/getHistory';
      // User user =
      //     await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      // Xây dựng URL với các tham số query
      var uri = Uri.parse(path);
      print(uri);
      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .get(uri.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        return List<OrderModel>.from(
            res.data.map((item) => OrderModel.fromJson(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load order : ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Lấy thông tin chi tiết hóa đơn
  // Lấy danh sách hóa đơn
  Future<List<OrderModel>> getDetaileBill(String billID) async {
    try {
      var path = '/Bill/getByID';
      // User user =
      //     await getUser(); // Kiểm tra và tải thông tin người dùng từ bộ nhớ đệm
      String token = await getToken();
      var uri = Uri.parse(path).replace(queryParameters: {
        'billID': billID,
      });
      // Build the URL with query parameters
      print(billID);
      // Gửi yêu cầu API
      Response res = await api.sendRequest
          .post(uri.toString(), options: Options(headers: header(token)));
      // Kiểm tra mã phản hồi
      if (res.statusCode == 200) {
        // Xử lý và trả về dữ liệu
        print('Lấy thông tin hóa đơn $billID thành công!');
        return List<OrderModel>.from(
            res.data.map((item) => OrderModel.fromJson(item)));
      } else {
        // Nếu có lỗi, ném ra ngoại lệ
        throw Exception('Failed to load order : ${res.statusCode}');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  // Xóa thông tin hóa đơn
  Future<bool> deleteBill(String billID) async {
    try {
      var path = '/Bill/remove';
      User user = await getUser();
      String token = await getToken();
      if (user.accountId.isNotEmpty) {
        // Xây dựng URL với các tham số query
        var uri = Uri.parse(path).replace(queryParameters: {
          'billID': billID,
        });

        // Gửi yêu cầu API
        Response res = await api.sendRequest.delete(
          uri.toString(),
          options: Options(headers: header(token)),
        );

        // Xử lý phản hồi
        if (res.statusCode == 200) {
          print("Delete bill successfully");
          return true;
        } else {
          print("Failed to delete bill: ${res.statusCode}");
          return false;
        }
      } else {
        return false;
      }
    } catch (ex) {
      print('Lỗi: $ex');
      rethrow;
    }
  }
}
