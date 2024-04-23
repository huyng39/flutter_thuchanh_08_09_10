// ignore_for_file: unused_label

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import '../../model/product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../product/productbody.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ProductWidget extends StatefulWidget {
  final int? brandId;
  const ProductWidget({super.key, this.brandId});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  // Product product = Product.productEmpty();
  // List<Product> lstPro = [];

  Future<List<Product>> getDataPro() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // // strPro = pref.getStringList('product')! as List<Product>;
    // // String strPro = pref.getString('product')!;
    // // lỗi key tại đây
    // List<String> lstStrPro = pref.getStringList('items')!;
    // lstPro = Product.fromJson(jsonDecode(lstStrPro as String)) as List<Product>;
    // setState(() {});
    // await Future.delayed(const Duration(seconds: 1));
    // return '';

    if (widget.brandId != null) {
      // Lấy thông tin product từ SQL lite
      // return await _databaseProduct
      //     .findProductId(int.parse(widget.brandId.toString()));
      // Lấy thông tin product từ API
      return await APIRepository().getProduct(widget.brandId);
    }

    // Lấy thông tin product từ SQL lite
    //return await _databaseProduct.products();

    // Lấy thông tin product từ API
    return await APIRepository().getProduct(widget.brandId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataPro();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: getDataPro(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.blue, size: 50));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ),
            );          
          } else {
            return Center(
              child: Column(
                children: [
                  Expanded(
                      child: GridView.builder(
                          itemCount: snapshot.data!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: ((context, index) {
                            final itemPro = snapshot.data![index];
                            return itemProView(itemPro, context);
                          })))
                ],
              ),
            );
          }
        });
  }
}
