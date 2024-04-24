import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:flutter_thuchanh_08/app/model/order.dart';
import 'package:flutter_thuchanh_08/app/model/order/orderDetaile.dart';
import 'package:flutter_thuchanh_08/app/model/product/product.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {
  OrderModel orderModel;
  OrderDetail({super.key, required this.orderModel});

  @override
  State<OrderDetail> createState() => _OrderDetaileState();
}

class _OrderDetaileState extends State<OrderDetail> {
  bool isOrderPlaced = false; // Trạng thái đơn hàng đã được đặt lại hay chưa
  OrderDetaileModel orderDetailModel = new OrderDetaileModel(
      productId: 1,
      productName: 'Iphone 15',
      imageUrl: 'Null',
      price: 15600000,
      count: 15,
      total: 256000000);
  final List<OrderDetaileModel> lstOrder = [];
  final List<Product> lstCreOrder = [];
  // Thực hiện gọi API sau khi nhận được id tham số đầu vào
  @override
  void initState() {
    // lstOrder.add(orderDetaileModel);
    // lstOrder.add(orderDetaileModel);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin đơn hàng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icon quay lại mặc định
          onPressed: () {
            // Xử lý sự kiện khi người dùng nhấn vào nút quay lại
            Navigator.pop(context, true); // Quay lại trang trước đó
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _buildSectionTitle('Đơn hàng đã hoàn thành',
            //     'Cảm ơn bạn đã mua sắm tại HL Mobile', Icons.favorite),
            _buildSectionTitle('Phuơng thức vận chuyển',
                'Người bán tự vận chuyển', Icons.local_shipping),
            SizedBox(height: 10),
            _buildOrderList(context),
            SizedBox(height: 10),
            Divider(),
            _buildSectionTitle('Phương thức thanh toán',
                'Thanh toán khi nhận hàng', Icons.payment),
            Divider(),
            SizedBox(height: 10),
            _buildSectionTitle('Ngày đặt hàng',
                '${widget.orderModel.dateCreated}', Icons.schedule),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Liên hệ shop
                // ElevatedButton.icon(
                //   icon: Icon(Icons.message, size: 24), // Kích thước icon
                //   label: Text("Liên hệ shop",
                //       style: TextStyle(fontSize: 16)), // Kích thước chữ
                //   onPressed: () {
                //     // Hành động khi nút được nhấn
                //     print("Liên hệ shop");
                //   },
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white,
                //     backgroundColor: Colors.blue, // Màu chữ và icon
                //     minimumSize: Size(150, 50), // Kích thước tối thiểu của nút
                //     padding: EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 10), // Padding bên trong nút
                //   ),
                // ),
                // Nút Mua lại
                ElevatedButton.icon(
                  icon: isOrderPlaced
                      ? Icon(Icons.check, size: 24)
                      : Icon(Icons.shopping_cart, size: 24), // Kích thước icon
                  label: isOrderPlaced
                      ? Text("Đã đặt lại", style: TextStyle(fontSize: 16))
                      : Text("Mua lại",
                          style: TextStyle(fontSize: 16)), // Kích thước chữ
                  onPressed: () {
                    // Hành động khi nút được nhấn

                    if (isOrderPlaced == false) {
                      _resetOrder(context);
                      print('Bạn vừa nhấn mua lại');
                    } else
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.warning,
                                    color: Colors.red), // Error icon
                                SizedBox(width: 5),
                                Text(
                                  "Thông báo từ hệ thống!",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            content: Text(
                              "Đơn hàng của bạn đã được thêm mới vui lòng kiểm tra lại!.",
                              style: TextStyle(color: Colors.black87),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Đóng"),
                              ),
                            ],
                          );
                        },
                      );
                    ;
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Màu chữ và icon
                    minimumSize: Size(150, 50), // Kích thước tối thiểu của nút
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Padding bên trong nút
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Thực hiện hành động đặt lại đơn hàng ở đây
      //     _resetOrder(context);
      //   },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }

  Widget _buildSectionTitle(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: Colors
                  .black87), // Icon widget to display the passed icon data
          const SizedBox(width: 8), // Space between icon and text
          Expanded(
            // Expanded to handle long texts
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetOrder(BuildContext context) async {
    // Thực hiện hành động đặt lại đơn hàng
    // Đây là nơi bạn có thể thực hiện các tác vụ như gửi yêu cầu đặt lại đơn hàng đến máy chủ, cập nhật trạng thái, v.v.
    // Sau khi hoàn thành, bạn có thể chuyển người dùng đến màn hình mới hoặc cập nhật lại dữ liệu
    // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderPage()));
    bool check = await APIRepository().addBill(lstCreOrder);
    if (check == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Đặt lại đơn hàng thành công!',
          style: TextStyle(color: Colors.green),
        ),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        isOrderPlaced = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Đặt lại đơn hàng không thành công!',
          style: TextStyle(color: Colors.red),
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<List<OrderDetaileModel>> _getDetaileBills() async {
    // Lấy thông tin product từ API
    List<OrderDetaileModel> lst =
        await APIRepository().getDetaileBill(widget.orderModel.id);

    // Tạo danh sách mới để tránh thay đổi lstCreOrder trong hàm này
    List<Product> updatedList = [];

    // Duyệt qua từng phần tử trong lst và thêm vào updatedList
    lst.forEach((orderDetail) {
      updatedList
          .add(Product(id: orderDetail.productId, quantity: orderDetail.count));
    });

    // Thêm updatedList vào lstCreOrder
    lstCreOrder.addAll(updatedList);

    return lst;
  }

  Widget _buildOrderList(BuildContext context) {
    return FutureBuilder<List<OrderDetaileModel>>(
      future: _getDetaileBills(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        double totalPrice =
            snapshot.data!.fold(0, (sum, item) => sum + item.total);
        lstOrder.addAll(snapshot.data!);
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông tin sản phẩm",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                    order.imageUrl!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, StackTrace) =>
                        Icon(Icons.image),
                  ),
                  title: Text(order.productName),
                  subtitle: Text(
                    'Số lượng: ${order.count}\nGiá: ${NumberFormat('###,###.### ₫').format(order.price)}',
                    textAlign: TextAlign.end,
                  ),
                );
              },
            ),
            Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thành tiền: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat('###,###.### ₫').format(totalPrice),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
