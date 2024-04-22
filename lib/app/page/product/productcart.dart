import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/model/product/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter_thuchanh_08/app/model/product/product_viewmodel.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({Key? key}) : super(key: key);

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  var lstProStr = "";
  List<Product> itemsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Danh sách hàng hóa đã chọn",
          style: TextStyle(
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: Consumer<ProductVM>(
            builder: (context, value, child) => Scaffold(
              body: SafeArea(
                child: Scaffold(
                  body: ListView.builder(
                      itemCount: value.lst.length,
                      itemBuilder: ((context, index) {
                        return itemListView(value.lst[index]);
                      })),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20), // Add some space between list and total
        Consumer<ProductVM>(
          builder: (context, value, child) {
            final totalQuantity = value.getTotalQuantity();
            final totalPrice = value.getTotalPrice();
            return Column(
              children: [
                Text(
                  'Tổng số lượng: $totalQuantity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tổng tiền: ${NumberFormat('###,###.### ₫').format(totalPrice)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Payment Button
                ElevatedButton.icon(
                  onPressed: () async {
                    if (value.lst.length > 0) {
                      // Handle payment logic here
                      bool check = await APIRepository().addBill(value.lst);
                      if (check == true) {
                        value.lst.clear();
                        print('Thanh toán thành công');
                        setState(() {
                          AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.scale,
                                title: 'Thanh toán thành công',
                                desc: 'Cảm ơn bạn đã mua hàng.',
                                btnOkOnPress: () {},
                                headerAnimationLoop: false,
                              ).show();
                        });
                        // setState(() {
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Column(
                        //           children: [
                        //             Icon(Icons.check_circle,
                        //                 color: Colors.green,size: 50,), // Success icon
                        //             SizedBox(width: 10),
                        //             Text(
                        //               "Thanh toán thành công",
                        //               style: TextStyle(color: Colors.green),
                        //             ),
                        //           ],
                        //         ),
                        //         content: Text(
                        //           "Cảm ơn bạn đã mua hàng.",
                        //           style: TextStyle(color: Colors.black87),
                        //         ),
                        //         actions: [
                        //           TextButton(
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: Text("Đóng"),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // });
                        
                      } else
                        print('Thanh toán không thành công');
                    } else {
                      AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.scale,
                                title: 'Không thể thanh toán',
                                desc: 'Vui lòng thêm ít nhất một sản phẩm\ntrước khi thanh toán',
                                btnOkOnPress: () {},
                                btnOkColor: Colors.red,
                                headerAnimationLoop: false,
                              ).show();
                      // Show dialog to add items
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //       title: Column(
                      //         children: [
                      //           Icon(
                      //             Icons.cancel,
                      //             color: Colors.red,
                      //             size: 50,
                      //           ), // Error icon
                      //           SizedBox(width: 5),
                      //           Text(
                      //             "Không thể thanh toán!",
                      //             style: TextStyle(color: Colors.red),
                      //           ),
                      //         ],
                      //       ),
                      //       content: Text(
                      //         "Vui lòng thêm ít nhất một sản phẩm trước khi thanh toán.",
                      //         style: TextStyle(color: Colors.black87),
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: Text("Đóng"),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                    backgroundColor:
                        Colors.blue, // Change the button color here
                    elevation: 5, // Add elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Rounded corner radius
                    ),
                  ),
                  icon: Icon(
                    Icons.payment,
                    color: Colors.white,
                  ), // Add icon here
                  label: Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Change text color
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget itemListView(Product productModel) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: NetworkImage(productModel.imageURL!),
            height: 100,
            width: 100,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.nameProduct ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormat('###,###.### ₫').format(productModel.price),
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                  selectionColor: const Color.fromARGB(255, 0, 0, 1),
                ),
                Text(
                  productModel.description!,
                  style: const TextStyle(fontSize: 15, color: Colors.blue),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<ProductVM>(
                      builder: (context, value, child) => IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          // Call a function to decrease quantity
                          if (productModel.quantity == 1) {
                            value.del(productModel.id!);
                          }
                          value.remove(productModel);
                        },
                      ),
                    ),
                    Text(
                      productModel.quantity.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    Consumer<ProductVM>(
                      builder: (context, value, child) => IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                        ),
                        onPressed: () {
                          // Call a function to decrease quantity
                          value.add(productModel);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
