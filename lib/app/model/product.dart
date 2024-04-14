import 'dart:ffi';

class Product {
  int? id;
  String? nameProduct;
  String? description;
  String? imageURL;
  double? price;
  int? categoryID;
  String? categoryName;
  
  Product({
    required this.id,
    required this.nameProduct,
    required this.description,
    required this.imageURL,
    required this.price,
    required this.categoryID,
    required this.categoryName,
  });

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
    return <String, dynamic>{
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
        id:  json["id"],
        nameProduct: json["name"],
        description: json["description"],
        imageURL: json["imageURL"] == null || json["imageURL"] == ''
            ? ""
            : json['imageURL'],
        price: json["price"],
        categoryID: json["categoryID"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = nameProduct;
    data['description'] = description;
    data['imageURL'] = imageURL;
    data['price'] = price;
    data['categoryID'] = categoryID;
    data['categoryName'] = categoryName;
    return data;
  }
}