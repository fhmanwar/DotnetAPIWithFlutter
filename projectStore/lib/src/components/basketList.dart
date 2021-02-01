import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectStore/src/models/cartModel.dart';

class BasketCard extends StatelessWidget {
  const BasketCard(this._cartModel);
  @required
  final CartModel _cartModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       topLeft: const Radius.circular(8.0),
            //       topRight: const Radius.circular(8.0),
            //     ),
            //     child: SizedBox(
            //       width: double.infinity,
            //       child: Image.network(
            //         imgSrc,
            //         fit: BoxFit.cover,
            //         height: 100,
            //       ),
            //     )),
            Container(
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.only(
                top: 5.0,
                left: 5.0,
                bottom: 5.0,
              ),
              height: 70,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.redAccent,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      _cartModel.productName,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.0)),
                    Text(
                      '${NumberFormat.currency(name: 'Rp ').format(_cartModel.productPrice)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity: ',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          '${_cartModel.qty}',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'SubTotal:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${NumberFormat.currency(name: 'Rp ').format(_cartModel.subtotal)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
