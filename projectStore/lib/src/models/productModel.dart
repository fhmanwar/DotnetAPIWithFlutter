class Product {
  int id;
  String name;
  String categoryName;
  int stock;
  int price;
  String unit;

  Product(
      {this.id,
      this.name,
      this.categoryName,
      this.stock,
      this.price,
      this.unit});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['productId'],
      name: json['productName'],
      categoryName: json['categoryName'],
      stock: json['stock'],
      price: json['price'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.id;
    data['productName'] = this.name;
    data['categoryName'] = this.categoryName;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['unit'] = this.unit;
    return data;
  }
}
