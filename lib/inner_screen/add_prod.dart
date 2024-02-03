import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/header.dart';
import '../widgets/loading_manager.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';
class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';
  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Bitcoin';
  int _groupValue = 1;
  bool isDouble = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  late final TextEditingController _titleController, _priceController, _descriptionController, _incomeController, _cycleDaysController;

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _incomeController = TextEditingController();
    _cycleDaysController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _incomeController.dispose();
    _cycleDaysController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;
    if (isValid) {
      _formKey.currentState!.save();
      if(_pickedImage == null) {
        GlobalMethods.errorDialog(subtitle: 'Please pick up an image', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        // Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('$_uuid.jpg');
        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'price': _priceController.text,
          'income': _incomeController.text,
          'cycleDays': _cycleDaysController.text,
          'salePrice': 0.1,
          'imageUrl': imageUrl.toString(),
          'productCategoryName': _catValue,
          'isOnSale': false,
          'isDouble': isDouble,
          'createdAt': Timestamp.now(),
        });
        clearFrom();
        Fluttertoast.showToast(
          msg: "Product uploaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(subtitle: '${error.message}', context: context);
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

  void clearFrom() {
    isDouble = false;
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _incomeController.clear();
    _cycleDaysController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
        filled: true,
        fillColor: _scaffoldColor,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.0),
        )
    );
    return Scaffold(
      key: context.read<menuController>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Header(fct: () {
                          context.read<menuController>().controlAddProductsMenu();
                        }, title: 'Add product', showTextField: false,),
                      ),
                      const SizedBox(height: 25,),
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
                                TextWidget(text: 'Title', color: color, isTitle: true),
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
                                        flex: 2,
                                        child: FittedBox(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              TextWidget(text: 'Price in \$', color: color, isTitle: true),
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
                                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                  ],
                                                  decoration: inputDecoration,
                                                ),
                                              ),
                                              const SizedBox(height: 20,),
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
                                              TextWidget(text: 'Product category', color: color, isTitle: true),
                                              const SizedBox(height: 10,),
                                              // Drop down menu code here
                                              Container(
                                                  color: _scaffoldColor,
                                                  child: _categoryDropDown()),
                                              const SizedBox(height: 20,),
                                              TextWidget(text: 'Quantity', color: color, isTitle: true),
                                              const SizedBox(height: 10,),
                                              //  Radio button code here
                                              Row(
                                                children: [
                                                  TextWidget(text: 'Single', color: color),
                                                  Radio(value: 1, groupValue: _groupValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _groupValue = 1;
                                                        isDouble = false;
                                                      });
                                                    },
                                                    activeColor: Colors.orangeAccent,
                                                  ),
                                                  TextWidget(text: 'Double', color: color),
                                                  Radio(value:2, groupValue: _groupValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _groupValue = 2;
                                                        isDouble = true;
                                                      });
                                                    },
                                                    activeColor: Colors.orangeAccent,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    // Image to be picked code is here
                                    Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: size.width > 650 ? 350 : size.width * 0.45,
                                            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(12.0)),
                                            child: _pickedImage == null ? dottedBorder(color: color) : ClipRRect(borderRadius: BorderRadius.circular(12),
                                            child: kIsWeb ? Image.memory(webImage, fit: BoxFit.fill,) :
                                            Image.file(_pickedImage!, fit: BoxFit.fill,),)
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: FittedBox(
                                          child: Column(
                                            children: [
                                              TextButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      _pickedImage = null;
                                                      webImage = Uint8List(8);
                                                    });
                                                  },
                                                  child: TextWidget(text: 'Clear', color: Colors.red,)),
                                              TextButton(
                                                onPressed: () {},
                                                child: TextWidget(text: 'Update image', color: Colors.orangeAccent,),)
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ButtonsWidget(
                                          onPressed: () {
                                            clearFrom();
                                          }, text: 'Clear form', icon: IconlyBold.danger, backgroundColor: Colors.red.shade300),
                                      ButtonsWidget(onPressed: () {
                                        _uploadForm();
                                      }, text: 'Upload', icon: IconlyBold.upload, backgroundColor: Colors.orangeAccent)
                                    ],
                                  ),
                                )
                              ]
                          ),
                        ),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Future <void> _pickImage() async {
    if(!kIsWeb){
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        var selected =File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if(kIsWeb){
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({
    required Color color,
  }){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: const [6.7],
        borderType: BorderType.RRect,
        color: color,
        radius: const Radius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, color: color, size: 50,),
              const SizedBox(height: 20,),
              TextButton(onPressed: () {
                _pickImage();
              }, child: TextWidget(text: 'Choose an image', color: Colors.orangeAccent,))
            ],),
        ),
      ),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize:18,),
              value: _catValue,
              onChanged: (value) {
                print(_catValue);
                setState(() {
                  _catValue = value!;
                });
              },
              hint: const Text('Select a category'),
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
            )),
      ),
    );
  }
}