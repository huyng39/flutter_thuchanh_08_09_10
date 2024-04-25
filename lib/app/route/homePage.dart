import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/app/page/product/productwidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const ProductWidget();
  }
}