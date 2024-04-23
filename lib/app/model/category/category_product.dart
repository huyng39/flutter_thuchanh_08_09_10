class Category {
  int? id;
  String name;
  String? imageURL;
  String description;
  
  Category({
    this.id,
    required this.name,
    this.imageURL,
    required this.description,
  });

  // static Category categoryEmpty() {
  //   return Category(
  //       id: null,
  //       name: '',
  //       description: '',
  //       imageURL: '');
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageURL': imageURL,
      'description': description,
    };
  }


  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id:  json["id"],
        name: json["name"],
        imageURL: json["imageURL"] == null || json["imageURL"] == ''
            ? ""
            : json['imageURL'],
        description: json["description"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['imageURL'] = imageURL;
    data['description'] = description;
    return data;
  }
}
