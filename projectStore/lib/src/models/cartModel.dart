class CartModel {
  int id;
  int userId;
  String productName;
  int productPrice;
  String categoryName;
  int qty;
  int subtotal;

  CartModel(
      {this.id,
      this.userId,
      this.productName,
      this.productPrice,
      this.categoryName,
      this.qty,
      this.subtotal});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['Id'],
      userId: json['userId'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      categoryName: json['categoryName'],
      qty: json['quantity'],
      subtotal: json['subTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['userId'] = this.userId;
    data['productName'] = this.productName;
    data['productPrice'] = this.productPrice;
    data['categoryName'] = this.categoryName;
    data['quantity'] = this.qty;
    data['subTotal'] = this.subtotal;
    return data;
  }
}
