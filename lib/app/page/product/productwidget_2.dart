// ignore_for_file: unused_label

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import '../../model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../product/productbody.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Center(
  //         child: Expanded(
  //             child: GridView.builder(
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                     childAspectRatio: 1,
  //                     crossAxisSpacing: 8,
  //                     mainAxisSpacing: 8),
  //                 itemBuilder: ((context, index) {
  //                   Container(
  //                     margin: const EdgeInsets.only(left: 5, right: 5),
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey.shade100,
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.5),
  //                           spreadRadius: 1.5,
  //                           blurRadius: 3,
  //                           offset: const Offset(0, 0.5),
  //                         )
  //                       ],
  //                     ),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         Image(
  //                           image: NetworkImage(product.imageURL!),
  //                           height: 100,
  //                           width: 100,
  //                           errorBuilder: (context, error, stackTrace) =>
  //                               const Icon(Icons.image),
  //                         ),
  //                         Text(
  //                           product.nameProduct ?? '',
  //                           textAlign: TextAlign.center,
  //                           style: const TextStyle(
  //                               fontSize: 14, fontWeight: FontWeight.bold),
  //                         ),
  //                         Text(
  //                           NumberFormat('###,###.### ₫').format(product.price),
  //                           style: const TextStyle(
  //                               fontSize: 15,
  //                               color: Colors.red,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                         Text(
  //                           product.description!,
  //                           style: const TextStyle(
  //                               fontSize: 12, color: Colors.blue),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 }))),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: getDataPro(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
              // child: LoadingAnimationWidget.discreteCircle(
              //   color: Colors.blue,
              //   size: 200,
              // ),
            );
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
                            return itemProView(itemPro,context);
                          })))
                ],
              ),
            );
          }
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Center(
  //         child: Expanded(
  //             child: GridView.builder(
  //                 itemCount: lstPro.length,
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                     childAspectRatio: 1,
  //                     crossAxisSpacing: 8,
  //                     mainAxisSpacing: 8),
  //                 itemBuilder: ((context, index) {
  //                  return itemProView(lstPro[index]);
  //                 }))),
  //       ),
  //     ),
  //   );
  // }
}
