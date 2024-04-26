import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:flutter_thuchanh_08/app/model/order.dart';
import 'package:flutter_thuchanh_08/app/route/orderHistoryDetaile.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BuyHistory extends StatefulWidget {
  const BuyHistory({super.key});

  @override
  State<BuyHistory> createState() => _buyHistoryState();
}

class _buyHistoryState extends State<BuyHistory> {
  // OrderModel orderHistory = new OrderModel(
  //     id: "0909123456",
  //     fullName: "Ngo Nhat Huy",
  //     dateCreated: "12/04/2024",
  //     total: 716800000);
  Future<List<OrderModel>> _getOrderHistory() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    //return await _databaseHelper.categories();
    // Lấy danh sác category từ API
    return await APIRepository().getBill();
  }

  List<OrderModel> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    _getOrderHistory();
    super.initState();
  }

  Future<List<OrderModel>> _getBills() async {
    // Lấy thông tin product từ API
    return await APIRepository().getBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử đơn hàng", style: titleStyle),
        backgroundColor: appBarBackgroundColor,
        iconTheme: iconBackColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ), // Icon làm mới
            onPressed: () {
              // Xử lý sự kiện khi người dùng nhấn vào nút làm mới
              // Đặt logic làm mới danh sách đơn hàng ở đây
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _getBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue, size: 50),
            );
          }
          // else if (snapshot.hasError) {
          //   return Center(
          //       child: Text(
          //         'Error: ${snapshot.error}',
          //         style: const TextStyle(color: Colors.red, fontSize: 20),
          //       ),
          //     );
          // }
          else {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Danh sách đơn hàng',
                  //       style: TextStyle(
                  //         fontSize: 24.0,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.refresh), // Icon làm mới
                  //       onPressed: () {
                  //         // Xử lý sự kiện khi người dùng nhấn vào nút làm mới
                  //         // Đặt logic làm mới danh sách đơn hàng ở đây
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 20.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final order = snapshot.data![index];
                        return OrderWidget(order);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget OrderWidget(OrderModel order) {
    return FutureBuilder<List<OrderModel>>(
      future: _getOrderHistory(),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () {
            print('Bạn vừa chọn hóa đơn ${order.id}');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetail(
                        orderModel: order,
                      )),
            ).then((value) {
              if (value == true) {
                // Nếu giá trị trả về là true, thực hiện cập nhật giao diện ở đây
                setState(() {
                  print('đã cập nhật');
                  // Cập nhật lại danh sách đơn hàng
                  setState(() {});
                });
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(thickness: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã đơn hàng:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${order.id.length > 23 ? order.id.substring(0, 23) + '...' : order.id}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: snapshot.data?.length ??
              //       0, // nếu snapshot.data = null => itemCount = 0
              //   itemBuilder: (context, index) {
              //     // final order = orders[index];
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               'Mã đơn hàng:',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(
              //               '${order.id.length > 23 ? order.id.substring(0, 23) + '...' : order.id}',
              //               style: TextStyle(color: Colors.black, fontSize: 16),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 8.0),
              //       ],
              //     );
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ngày đặt:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${order.dateCreated}',
                      style: TextStyle(
                          color: Color.fromARGB(255, 64, 61, 61), fontSize: 16),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nút xóa hóa đơn
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.red, // Màu nền của nút
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3), // Đổ bóng
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () async {
                          // Xử lý logic khi nút được nhấn
                          // Ví dụ: Xóa hóa đơn
                          print('Bạn vừa chọn xóa hóa đơn');
                          bool check =
                              await APIRepository().deleteBill(order.id);
                          if (check) {
                            setState(() {
                              // AwesomeDialog(
                              //   context: context,
                              //   dialogType: DialogType.success,
                              //   animType: AnimType.scale,
                              //   title: 'Xoá thành công',
                              //   desc:
                              //       'Hóa đơn \n${order.id}\nđã được xóa thành công.',
                              //   btnOkOnPress: () {},
                              //   headerAnimationLoop: false,
                              //   btnOkText: "Đóng",
                              // ).show();
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       title: Row(
                              //         children: [
                              //           Icon(Icons.check_circle,
                              //               color: Colors.green), // Success icon
                              //           SizedBox(width: 5),
                              //           Text(
                              //             "Thông báo từ hệ thống !",
                              //             style: TextStyle(color: Colors.green),
                              //           ),
                              //         ],
                              //       ),
                              //       content: Text(
                              //         "Hóa đơn ${order.id} đã được xóa thành công.",
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
                            });
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.scale,
                              title: 'Không thể xóa',
                              desc: 'Vui lòng kiểm tra lại server!',
                              btnOkOnPress: () {},
                              headerAnimationLoop: false,
                              btnOkText: "Đóng",
                            ).show();
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: Row(
                            //         children: [
                            //           Icon(Icons.error,
                            //               color: Colors.red), // Error icon
                            //           SizedBox(width: 5),
                            //           Text(
                            //             "Không thể xóa!",
                            //             style: TextStyle(color: Colors.red),
                            //           ),
                            //         ],
                            //       ),
                            //       content: Text(
                            //         "Vui lòng kiểm tra lại thông tin server!.",
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
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white, // Màu icon
                              ),
                              Text(
                                'Xóa hóa đơn',
                                style: TextStyle(
                                    color: Colors.white, // Màu chữ
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            'Tổng cộng:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            NumberFormat('###,###.### ₫').format(order.total),
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(thickness: 2.0),
            ],
          ),
        );
      },
    );
  }
}
