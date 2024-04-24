import 'dart:convert';
import 'dart:io';

class Product {
  int? id;
  String? nameProduct;
  String? description;
  String? imageURL;
  int? price;
  int? categoryID;
  String? categoryName;
  int? quantity;
  bool? isLike;

  Product(
      {this.id,
      this.nameProduct,
      this.description,
      this.imageURL,
      this.price,
      this.categoryID,
      this.categoryName,
      this.quantity = 1,
      this.isLike = false});

  static Product productEmpty() {
    return Product(
        id: null,
        nameProduct: '',
        description: '',
        imageURL: '',
        price: null,
        categoryID: null,
        categoryName: '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameProduct': nameProduct,
      'description': description,
      'imageURL': imageURL,
      'price': price,
      'categoryID': categoryID,
      'categoryName': categoryName,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        nameProduct: json["name"],
        description: json["description"],
        imageURL: json["imageURL"],
        price: json["price"],
        categoryID: json["categoryID"],
        categoryName: json["categoryName"],
      );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['name'] = nameProduct;
  //   data['description'] = description;
  //   data['imageURL'] = imageURL;
  //   data['price'] = price;
  //   data['categoryID'] = categoryID;
  //   data['categoryName'] = categoryName;
  //   return data;
  // }

  String toJson() => json.encode(toMap());
  @override
  String toString() =>
      'ProductModel(id: $id, name: $nameProduct,price:$price,img:$imageURL ,desc: $description,catId:$categoryID)';
}
