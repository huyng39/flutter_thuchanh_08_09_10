import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/model/product/product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../model/product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// class ProductBody extends StatefulWidget {
//   const ProductBody({super.key});

//   @override
//   State<ProductBody> createState() => _ProductBodyState();
// }
//   Product product = Product.productEmpty();
// class _ProductBodyState extends State<ProductBody> {
//   // khi dùng tham số truyền vào phải khai báo biến trùng tên require
//   getDataPro() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String strPro = pref.getString('product')!;

//     product = Product.fromJson(jsonDecode(strPro));
//     setState(() {});
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getDataPro();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return Container(
//     //   margin: const EdgeInsets.only(left: 5, right: 5),
//     //   padding: const EdgeInsets.all(8),
//     //   decoration: BoxDecoration(
//     //     color: Colors.grey.shade100,
//     //     borderRadius: BorderRadius.circular(10.0),
//     //     boxShadow: [
//     //       BoxShadow(
//     //         color: Colors.grey.withOpacity(0.5),
//     //         spreadRadius: 1.5,
//     //         blurRadius: 3,
//     //         offset: const Offset(0, 0.5),
//     //       )
//     //     ],
//     //   ),
//     //   child: Column(
//     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //     children: [
//     //       // Image.asset(
//     //       //   urlimg + productModel.img!,
//     //       //   height: 100,
//     //       //   width: 100,
//     //       //   errorBuilder: (context, error, stackTrace) =>
//     //       //       const Icon(Icons.image),
//     //       // ),
//     //       Image(
//     //         image: NetworkImage(product.imageURL!),
//     //         height: 100,
//     //         width: 100,
//     //         errorBuilder: (context, error, stackTrace) =>
//     //             const Icon(Icons.image),
//     //         ),
//     //       Text(
//     //         product.nameProduct ?? '',
//     //         textAlign: TextAlign.center,
//     //         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//     //       ),
//     //       Text(
//     //         NumberFormat('###,###.### ₫').format(product.price),
//     //         style: const TextStyle(
//     //             fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
//     //       ),
//     //       Text(
//     //         product.description!,
//     //         style: const TextStyle(fontSize: 12, color: Colors.blue),
//     //       ),
//     //     ],
//     //   ),
//     // );
//     return itemProView(product);
//   }
// }

Widget itemProView(Product productModel, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(left: 5, right: 5),
    padding: const EdgeInsets.all(2),
    width: 100,
    height: 250.0,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1.5,
          blurRadius: 3,
          offset: const Offset(0, 0.5),
        )
      ],
    ),
    child: Consumer<ProductVM>(
      builder: (context, value, child) {
        bool isLiked =
            value.lstFavorite.any((element) => element.id == productModel.id);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Image(
                  image: NetworkImage(productModel.imageURL!),
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image),
                ),
                Positioned(
                  top: -10,
                  right: -32,
                  left: 40,
                  child: IconButton(
                    onPressed: () {
                      print('Bạn vừa nhấn nút thả tim');
                      value.addOrRemoveFavorites(productModel);
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Image.asset(
            //   urlimg + productModel.img!,
            //   height: 100,
            //   width: 100,
            //   errorBuilder: (context, error, stackTrace) =>
            //       const Icon(Icons.image),
            // ),

            Text(
              productModel.nameProduct ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              NumberFormat('###,###.### ₫').format(productModel.price),
              style: const TextStyle(
                  fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            // Text(
            //   productModel.description!,
            //   style: const TextStyle(fontSize: 11, color: Colors.blue),
            // ),
            Consumer<ProductVM>(
              builder: (context, value, child) => ElevatedButton.icon(
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  value.add(productModel);
                },
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
