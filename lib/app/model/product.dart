// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  int? id;
  String? nameProduct;
  String? description;
  String? imageURL;
  int? price;
  int? categoryID;
  String? categoryName;
  
  Product({
    required this.id,
    this.nameProduct,
    this.description,
    this.imageURL,
    this.price,
    this.categoryID,
    this.categoryName,
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
}
