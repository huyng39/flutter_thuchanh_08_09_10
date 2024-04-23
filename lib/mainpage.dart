import 'dart:convert';
import 'package:flutter_thuchanh_08/app/model/category/category.dart';
import 'package:flutter_thuchanh_08/app/model/product/cartcounter.dart';
import 'package:flutter_thuchanh_08/app/model/product/product.dart';
import 'package:flutter_thuchanh_08/app/model/product/product_viewmodel.dart';
import 'package:flutter_thuchanh_08/app/model/user/user.dart';
import 'package:flutter_thuchanh_08/app/page/category/category_list.dart';
import 'package:flutter_thuchanh_08/app/page/detail.dart';
import 'package:flutter_thuchanh_08/app/route/page1.dart';
import 'package:flutter_thuchanh_08/app/route/page2.dart';
import 'package:flutter_thuchanh_08/app/route/page3.dart';
import 'package:flutter_thuchanh_08/app/page/product/productwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/page/defaultwidget.dart';
import '../app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_thuchanh_08/app/page/product/productcart.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
    print(user.imageURL);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "Home";
    switch (index) {
      case 0:
        nameWidgets = "Home";
        break;
      case 1:
        {
          return const CategoryList();
        }
      // nút all product dành cho việc thử nghiệm get list sản phẩm
      case 2:
        {
          return const ProductWidget();
        }
      case 3:
        {
          return const ProductCart();
        }
      case 4:
        {
          return const Detail();
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("HL Mobile"),
        // backgroundColor: Colors.blue,
        // foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL!.length < 5
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            user.imageURL!,
                          )),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(user.fullName!,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Buy History'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 1;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 2;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorite List'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Page1()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Change password'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()));
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.pages),
            //   title: const Text('Page3'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _selectedIndex = 0;
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => const Page3()));
            //   },
            // ),
            const Divider(
              color: Colors.black,
            ),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          // nút all product dành cho việc thử nghiệm get list sản phẩm
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'All product',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Positioned(
                  child: Icon(Icons.shopping_cart),
                ), // Icon mặc định
                Consumer<ProductVM>(
                  builder: (context, value, child) {
                    if (value.lst.length > 0) {
                      return Positioned(
                        right: 0,
                        child: Consumer<ProductVM>(
                          builder: (context, value, child) => CartCounter(
                            count: value.lst.length.toString(),
                          ),
                        ),
                      );
                    } else {
                      return const Positioned(
                        child: Icon(Icons.shopping_cart),
                      );
                    }
                  },
                ),

                // Icon mặc định
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
