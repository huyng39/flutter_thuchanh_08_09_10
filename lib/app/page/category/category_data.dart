import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/data/api.dart';
import 'package:flutter_thuchanh_08/mainpage.dart';
import 'package:flutter_thuchanh_08/app/model/category/category_product.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_thuchanh_08/app/page/product/productwidget_bycate.dart';

// import 'category_add.dart';

class CategoryBuilder extends StatefulWidget {
  const CategoryBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryBuilder> createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  //final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Category>> _getCategorys() async {
    // thêm vào 1 dòng dữ liệu nếu getdata không có hoặc chưa có database
    //return await _databaseHelper.categories();
    // Lấy danh sác category từ API
    return await APIRepository().getCategory();
  }

  // Future<void> _onDelete(int id) async {
  //   bool check = await APIRepository().deleteCategory(id);
  //   if (check == true) {
  //     setState(() {});
  //   } else {
  //     print('Xóa không thành công');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _getCategorys(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue, size: 50));
        }
        // else if (snapshot.hasError) {
        //   return Center(
        //     child: Text(
        //       'Error: ${snapshot.error}',
        //       style: const TextStyle(color: Colors.red, fontSize: 20),
        //     ),
        //   );
        // }
        else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Category itemCat = snapshot.data![index];
                return _buildCategory(itemCat, context);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildCategory(Category breed, BuildContext context) {
    return Card(
        child: InkWell(
      // onTap: () {
      //   print('Bạn vừa chọn danh mục ${breed.id}');
      //   _onCategorySelected(context, breed.id!);
      // },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductWidget(
              objCat: breed,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Container(
            //   height: 40.0,
            //   width: 40.0,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.grey[300],
            //   ),
            //   alignment: Alignment.center,
            //   child: Text(
            //     breed.id.toString(),
            //     style: const TextStyle(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Container(
              width: 140,
              height: 100,
              alignment: Alignment.center,
              child: breed.imageURL != null
                  ? Image.network(
                      breed.imageURL!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    )
                  : Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(breed.description),
                ],
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       // setState(() {
            //       //   // DatabaseHelper().deleteCategory(breed.id!);
            //       _onDelete(breed.id!);
            //       // });
            //     },
            //     icon: const Icon(
            //       Icons.delete,
            //       color: Colors.red,
            //     )),
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context)
            //         .push(
            //           MaterialPageRoute(
            //             builder: (_) => CategoryAdd(
            //               isUpdate: true,
            //               categoryModel: breed,
            //             ),
            //             fullscreenDialog: true,
            //           ),
            //         )
            //         .then((_) => setState(() {}));
            //   },
            //   icon: Icon(
            //     Icons.edit,
            //     color: Colors.yellow.shade800,
            //   ),
            // )
          ],
        ),
      ),
    ));
  }
}

// void _onCategorySelected(BuildContext context, int catID) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => Mainpage(selectedCategory: catID),
//     ),
//   );
// }
