class OrderModel {
  String? id;
  String? fullName;
  String? dateCreated;
  int? total;

  OrderModel({
    this.id,
    this.fullName,
    this.dateCreated,
    this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        fullName: json["fullName"],
        dateCreated: json["dateCreated"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "dateCreated": dateCreated,
        "total": total,
      };
}
