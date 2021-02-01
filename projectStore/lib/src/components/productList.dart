import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectStore/src/models/productModel.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       topLeft: const Radius.circular(8.0),
            //       topRight: const Radius.circular(8.0),
            //     ),
            //     child: SizedBox(
            //       // height: 250,
            //       width: double.infinity,
            //       child: Image.network(
            //         imgSrc,
            //         fit: BoxFit.cover,
            //       ),
            //     )),
            Container(
              height: 70,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                color: Colors.redAccent,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.storefront,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.only(top: 5.0),
                // height: 100,
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.0)),
                    Text(
                      '${NumberFormat.currency(name: 'Rp').format(product.price)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
