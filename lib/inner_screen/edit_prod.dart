import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/loading_manager.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';
import 'package:firebase/firebase.dart' as fb;

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.productCat,
    required this.imageUrl,
    required this.isDouble,
    required this.isOnSale,
    required this.salePrice,
    required this.description,
    required this.income,
    required this.cycleDays,
  }) : super(key: key);
  final String id, title, price, productCat, imageUrl,description, income, cycleDays ;
  final bool isDouble, isOnSale;
  final double salePrice;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>{
  final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController, _priceController,  _descriptionController, _incomeController, _cycleDaysController;
  // Category
  late String _catValue;
  //Sale
  String? _salePercent;
  late String percToShow;
  late double _salePrice;
  late bool _isOnSale;
  //Image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  // Single or Double
  late int val;
  late bool _isDouble;
  // while loading
  bool _isLoading = false;
  @override
  void initState() {
    // //   set the price and title initial values and initialize the controllers
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _incomeController = TextEditingController(text: widget.income);
    _cycleDaysController = TextEditingController(text: widget.cycleDays);
    //  set the variables
    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;
    _isDouble = widget.isDouble;
    val = _isDouble ? 2 : 1;
    _imageUrl = widget.imageUrl;
    // 'https://media.istockphoto.com/id/185284489/photo/orange.webp?b=1&s=170667a&w=0&k=20&c=a9rTa5lUsFBIz3RkL-dTXZV3oa9iRmP1lMVyTPoPA60=';
    //  Calculate the percentage
    percToShow = (100 - (_salePrice * 100) / double.parse(widget.price)) . round().toStringAsFixed(1) + '%';
    super.initState();
    //Will be the price instead of 1.88
  }
  @override
  void dispose() {
    // Dispose the controllers
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _incomeController.dispose();
    _cycleDaysController.dispose();
    super.dispose();
  }
  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        if(_pickedImage != null) {
          fb.StorageReference storageRef = fb.storage().ref().child('products$_pickedImage').child('${widget.id}.jpg');
          final fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
          imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        }
        await FirebaseFirestore.instance.collection('products').doc(widget.id).update({
          'title': _titleController.text,
          'price': _priceController.text,
          'description': _descriptionController.text,
          'income': _incomeController.text,
          'cycleDays': _cycleDaysController.text,
          'salePrice': _salePrice,
          'imageUrl': _pickedImage == null ? widget.imageUrl : imageUri.toString(),
          'productCategoryName': _catValue,
          'isOnSale': _isOnSale,
          'isDouble': _isDouble,
        });
        await Fluttertoast.showToast(
          msg: "Product uploaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(filled: true, fillColor: _scaffoldColor, border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0,),
      ),
    );
    return Scaffold(
      // key: context.read<menuController>().getEditProductscaffoldKey,
      // drawer: const SideMenu(),
      body: LoadingManager(
              isLoading: _isLoading,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      // Header(showTextField: false, fct: () {context.read<menuController>().controlEditProductsMenu();},
                      //   title: 'Edit this product',
                      // ),
                      Container(
                        width: size.width > 650 ? 650 : size.width,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextWidget(text: 'Product title*', color: color, isTitle: true,),
                              const SizedBox(height: 10,),
                              TextFormField(
                                controller: _titleController,
                                key: const ValueKey('Title'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Title';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(height: 20,),
                              TextWidget(text: 'Description', color: color, isTitle: true),
                              const SizedBox(height: 10,),
                              TextFormField(
                                minLines: 10,
                                maxLines: 20,
                                keyboardType: TextInputType.multiline,
                                controller: _descriptionController,
                                key: const ValueKey('description'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Title';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextWidget(text: 'Price in \$*', color: color, isTitle: true,),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            width: 100,
                                            child: TextFormField(
                                              controller: _priceController,
                                              key: const ValueKey('Price  \$'),
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Price is missed';
                                                }
                                                return null;
                                              },
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.]')),
                                              ],
                                              decoration: inputDecoration,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextWidget(text: 'Daily Income', color: color, isTitle: true),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            width: 100,
                                            child: TextFormField(
                                              controller: _incomeController,
                                              key: const ValueKey('income'),
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Price is missed';
                                                }
                                                return null;
                                              },
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                              ],
                                              decoration: inputDecoration,
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextWidget(text: 'Cycle Days', color: color, isTitle: true),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            width: 100,
                                            child: TextFormField(
                                              controller: _cycleDaysController,
                                              key: const ValueKey('cycleDays'),
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Price is missed';
                                                }
                                                return null;
                                              },
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                              ],
                                              decoration: inputDecoration,
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextWidget(text: 'Product category*', color: color, isTitle: true,),
                                          const SizedBox(height: 10),
                                          Container(
                                            color: _scaffoldColor,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: catDropDownWidget(color),
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextWidget(text: 'Measure unit*', color: color, isTitle: true,),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                  text: 'Single', color: color),
                                              Radio(
                                                value: 1,
                                                groupValue: val,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = 1;
                                                    _isDouble = false;
                                                  });
                                                },
                                                activeColor: Colors.green,
                                              ),
                                              TextWidget(
                                                  text: 'Double', color: color),
                                              Radio(
                                                value: 2,
                                                groupValue: val,
                                                onChanged: (value) {
                                                  setState(() {
                                                    val = 2;
                                                    _isDouble = true;
                                                  });
                                                },
                                                activeColor: Colors.green,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _isOnSale,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _isOnSale = newValue!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextWidget(text: 'Sale', color: color, isTitle: true,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          AnimatedSwitcher(
                                            duration: const Duration(seconds: 1),
                                            child: !_isOnSale
                                                ? Container()
                                                : Row(
                                              children: [
                                                TextWidget(text: "\$" + _salePrice.toStringAsFixed(2), color: color),
                                                const SizedBox(width: 10,),
                                                salePourcentageDropDownWidget(color),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        height: size.width > 650 ? 350 : size.width * 0.45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12,),
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                                          child: _pickedImage == null ? Image.network(_imageUrl) : (kIsWeb)
                                              ? Image.memory(webImage,
                                            fit: BoxFit.fill,
                                          )
                                              : Image.file(
                                            _pickedImage!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: TextButton(onPressed: () {
                                              _pickImage();
                                            },
                                              child: TextWidget(text: 'Update image', color: Colors.blue,),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonsWidget(
                                      onPressed: () async {
                                        GlobalMethods.warningDialog(
                                            title: 'Delete?',
                                            subtitle: 'Press okay to confirm',
                                            fct: () async {
                                              await FirebaseFirestore.instance.collection('products').doc(widget.id).delete();
                                              await Fluttertoast.showToast(
                                                msg: "Product has been deleted",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                              );
                                              while(Navigator.canPop(context)) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            context: context);
                                      },
                                      text: 'Delete',
                                      icon: IconlyBold.danger,
                                      backgroundColor: Colors.red.shade700,
                                    ),
                                    ButtonsWidget(
                                      onPressed: () {
                                        _updateProduct();
                                      },
                                      text: 'Update',
                                      icon: IconlyBold.setting,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(value: '10', child: Text('10%'),),
          DropdownMenuItem<String>(value: '15', child: Text('15%'),),
          DropdownMenuItem<String>(value: '25', child: Text('25%'),),
          DropdownMenuItem<String>(value: '50', child: Text('50%'),),
          DropdownMenuItem<String>(value: '75', child: Text('75%'),),
          DropdownMenuItem<String>(value: '0', child: Text('0%'),),
        ],
        onChanged: (value) {
          if (value == '0') {
            return;
          } else {
            setState(() {
              _salePercent = value;
              _salePrice = double.parse(widget.price) - (double.parse(value!) * double.parse(widget.price) / 100);
            });
          }
        },
        hint: Text(_salePercent ?? percToShow),
        value: _salePercent,
      ),
    );
  }
  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem(value: 'Bitcoin',child: Text('Bitcoin'),),
          DropdownMenuItem(value: 'Ethereum',child: Text('Ethereum'),),
          DropdownMenuItem(value: 'Tether',child: Text('Tether'),),
          DropdownMenuItem(value: 'Binance coin',child: Text('Binance coin'),),
          DropdownMenuItem(value: 'Ripple',child: Text('Ripple'),),
          DropdownMenuItem(value: 'Usd-coin',child: Text('Usd-coin'),),
          DropdownMenuItem(value: 'Cardano',child: Text('Cardano'),),
          DropdownMenuItem(value: 'Doge coin',child: Text('Doge coin'),),
          DropdownMenuItem(value: 'Solana',child: Text('Solana'),),
          DropdownMenuItem(value: 'Tron',child: Text('Tron'),),
          DropdownMenuItem(value: 'Polkadot',child: Text('Polkadot'),),
          DropdownMenuItem(value: 'Matic-network',child: Text('Matic-network'),),
          DropdownMenuItem(value: 'Litecoin',child: Text('Litecoin'),),
          DropdownMenuItem(value: 'Shiba-inu',child: Text('Shiba-inu'),),
          DropdownMenuItem(value: 'Wrapped-bitcoin',child: Text('Wrapped-bitcoin'),),
          DropdownMenuItem(value: 'Dai',child: Text('Dai'),),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('Select a Category'),
        value: _catValue,
      ),
    );
  }

  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log('No file selected');
        // showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log('No file selected');
      }
    } else {
      log('Perm not granted');
    }
  }
}