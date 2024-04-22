import 'package:flutter/material.dart';
import 'package:flutter_thuchanh_08/animation/constants.dart';
import 'skeleton.dart';

class ProductBodySkeleton extends StatelessWidget {
  const ProductBodySkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Skeleton(height: 120, width: 120),
        const SizedBox(width: defaultPadding),
        Expanded(
         child: GridView.builder(
                          itemCount: 2,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: ((context, index) {
                            
                          })))
      ],
    );
  }
}