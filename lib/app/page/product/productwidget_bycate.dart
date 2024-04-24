// ignore_for_file: unused_label
import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/config/const.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:flutter_thuchanh_08/app/model/product/cartcounter.dart';
import 'package:flutter_thuchanh_08/app/model/product/product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../model/product/product.dart';
import 'productbody.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_thuchanh_08/app/model/category/category_product.dart';

class ProductWidget extends StatefulWidget {
  // final int? brandId;
  final Category? objCat;
  const ProductWidget({Key? key, this.objCat}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  // Product product = Product.productEmpty();
  // List<Product> lstPro = [];

  Future<List<Product>> getDataProById(int catId) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // // strPro = pref.getStringList('product')! as List<Product>;
    // // String strPro = pref.getString('product')!;
    // // lỗi key tại đây
    // List<String> lstStrPro = pref.getStringList('items')!;
    // lstPro = Product.fromJson(jsonDecode(lstStrPro as String)) as List<Product>;
    // setState(() {});
    // await Future.delayed(const Duration(seconds: 1));
    // return '';

    if (widget.objCat != null) {
      // Lấy thông tin product từ SQL lite
      // return await _databaseProduct
      //     .findProductId(int.parse(widget.brandId.toString()));
      // Lấy thông tin product từ API
      return await APIRepository().getProductbyCategory(catId);
    }

    // Lấy thông tin product từ SQL lite
    //return await _databaseProduct.products();

    // Lấy thông tin product từ API
    return await APIRepository().getProductbyCategory(catId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataProById(widget.objCat!.id as int);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.objCat?.name.toString()}',
          style: titleStyle,
        ),
        backgroundColor: appBarBackgroundColor,
        iconTheme: iconBackColor,
        actions: [
          InkWell(
            onTap: () {
              // Navigator.pop(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProductCart(),
              //   ),
              // );
              // chuyển về tab 2: Product
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 15, top: 8, bottom: 8),
              child: Stack(
                children: [
                  const Align(
                      child: Icon(
                        Icons.shopping_bag,
                        size: 24,
                        color: Colors.white,
                      )),
                  Consumer<ProductVM>(
                    builder: (context, value, child) {
                      if (value.lst.length > 0) {
                        return Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Consumer<ProductVM>(
                            builder: (context, value, child) => CartCounter(
                              count: value.lst.length.toString(),
                            ),
                          ),
                        );
                      } else {
                        return const Align(
                            // alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.shopping_bag,
                              size: 24,
                              color: Colors.white,
                            ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
          future: getDataProById(widget.objCat!.id as int),
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
          }),
    );
  }
}
