

import 'package:admincontrol/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../inner_screen/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key, required this.id,}) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();

}

class _ProductWidgetState extends State<ProductWidget>{
  String title = '';
  String description = '';
  String income = '';
  String cycleDays = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isDouble = false;

  @override
  void initState() {
    getProductData();
    super.initState();
  }

  Future<void> getProductData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance.collection('products').doc(widget.id).get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          title = productsDoc.get('title');
          description = productsDoc.get('description');
          income = productsDoc.get('income');
          cycleDays = productsDoc.get('cycleDays');
          productCat = productsDoc.get('productCategoryName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
          salePrice = productsDoc.get('salePrice');
          isOnSale = productsDoc.get('isOnSale');
          isDouble = productsDoc.get('isDouble');
        });
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor.withOpacity(0.6),
          child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProductScreen(
                  id: widget.id,
                  title: title,
                  price: price,
                  description: description,
                  income: income,
                  cycleDays: cycleDays,
                  salePrice: salePrice,
                  productCat: productCat,
                  imageUrl:
                  imageUrl == null?
                  'https://media.istockphoto.com/id/185284489/photo/orange.webp?b=1&s=170667a&w=0&k=20&c=a9rTa5lUsFBIz3RkL-dTXZV3oa9iRmP1lMVyTPoPA60='
                      : imageUrl!,
                  isOnSale: isOnSale,
                  isDouble: isDouble,
                )));
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 3,
                              child: Image.network(
                                imageUrl == null?
                                'https://www.freepnglogos.com/uploads/bitcoin-png/bitcoin-all-about-bitcoins-9.png'
                                    : imageUrl!,
                                fit: BoxFit.fill,
                                height: size.width * 0.12,
                              )
                          ),
                          const Spacer(),
                          PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {},
                                  value: 1,
                                  child: const Text('Edit'),
                                ),
                                PopupMenuItem(
                                  onTap: () {},
                                  value: 1,
                                  child: const Text('Delete', style: TextStyle(color: Colors.red),),
                                )
                              ])
                        ],
                      ),
                      const SizedBox(height: 2,),
                      Row(
                        children: [
                          TextWidget(text:  isOnSale ? '\$${salePrice.toStringAsFixed(2)}' : '\$$price',
                            color: color, textSize: 10,),
                          const SizedBox(width: 7,),
                          Visibility(
                            visible: isOnSale,
                            child: Text('INR$price',
                              style: TextStyle(decoration: TextDecoration.lineThrough, color: color),),
                          ),
                          const Spacer(),
                          TextWidget(text: isDouble ? 'Single' : 'Double', color: color, textSize: 18,),
                        ],),
                      const SizedBox(height: 2,),
                      TextWidget(text: title, color: color, textSize: 24, isTitle: true),
                    ],
                  )
              )

          ),
        )
    );
  }

}