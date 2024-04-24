import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/model/product/product.dart';
import 'package:flutter_thuchanh_08/app/model/product/product_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  // final DatabaseProduct _databaseProduct = DatabaseProduct();

  // Future<List<Product>> _getProductsFavor() async {
  //   return await _databaseProduct.products();
  // }

  List<Product> itemlst = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách yêu thích",style: titleStyle),
        backgroundColor: appBarBackgroundColor,
        iconTheme: iconBackColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductVM>(
              builder: (context, value, child) => Scaffold(
                body: SafeArea(
                  child: Scaffold(
                    body: ListView.builder(
                        itemCount: value.lstFavorite.length,
                        itemBuilder: (context, index) {
                          return _buildFavorite(
                              value.lstFavorite[index], context);
                        }),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              height:
                  16), // Khoảng cách giữa danh sách sản phẩm và nút quay lại
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context)
          //         .pop(); // Quay lại trang trước đó khi nhấn nút quay lại
          //   },
          //   child: Text('Quay lại'),
          // ),
        ],
      ),
    );
  }
  Widget _buildFavorite(Product product, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for the card
      ),
      child: InkWell(
        // onTap: () {
        //   print('Bạn vừa nhấn vào category ${product.name} này!');
        // },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 120,
                        child: product.imageURL != 'null' &&
                                product.imageURL!
                                    .isNotEmpty // Kiểm tra xem product.img có khác null và không rỗng không
                            ? Image.network(
                                product.imageURL!, // Hình ảnh sản phẩm

                                fit: BoxFit.contain,
                              )
                            : Icon(Icons
                                .image), // Nếu không có hình ảnh, hiển thị icon mặc định
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.nameProduct!, // Product title
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     ...List.generate(5, (index) {
                            //       return Icon(
                            //         index < 5 ? Icons.star : Icons.star_border,
                            //         size: 20,
                            //         color: Colors.amber,
                            //       );
                            //     }),
                            //     SizedBox(width: 8),
                            //     Text('126'),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  NumberFormat('###,###.### ₫').format(product.price), // Current price
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .red, // or Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            // Text(
                            //   'Identifier number', // Placeholder for an identifier
                            //   style:
                            //       TextStyle(fontSize: 12, color: Colors.grey),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Consumer<ProductVM>(
                    builder: (context, value, child) => Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                          onPressed: () {
                            value.removeFavorite(product);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          )),
                    ),
                  ),

                  // Consumer<ProductVM>(
                  //   builder: (context, value, child) => Positioned(
                  //     right: 0,
                  //     bottom: 35,
                  //     child: IconButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             // DatabaseProduct().deleteProduct(product.id!);
                  //           });
                  //           print('Bạn vừa nhấn nút add');
                  //           // value.add(product);
                  //         },
                  //         icon: const Icon(
                  //           Icons.add_shopping_cart,
                  //           color: Colors.red,
                  //           size: 20,
                  //         )),
                  //   ),
                  // ),
                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   child: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           Navigator.of(context)
                  //               .push(
                  //                 MaterialPageRoute(
                  //                   builder: (_) => ProductAdd(
                  //                     isUpdate: true,
                  //                     productModel: product,
                  //                   ),
                  //                   fullscreenDialog: true,
                  //                 ),
                  //               )
                  //               .then((_) => setState(() {}));
                  //         });
                  //       },
                  //       icon: Icon(
                  //         Icons.edit,
                  //         color: Colors.yellow.shade800,
                  //         size: 20,
                  //       )),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
