class TransactionItemModel {
  String productName;
  String categoryName;
  int quantity;
  int subtotal;

  TransactionItemModel(
      {this.productName, this.categoryName, this.quantity, this.subtotal});

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      productName: json['productName'],
      categoryName: json['categoryName'],
      quantity: json['quantity'],
      subtotal: json['subTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['categoryName'] = this.categoryName;
    data['quantity'] = this.quantity;
    data['subTotal'] = this.subtotal;
    return data;
  }
}
