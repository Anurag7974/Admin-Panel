import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/loading_manager.dart';
import '../widgets/text_widget.dart';

class AddNewsListScreen extends StatefulWidget {
  static const routeName = '/AddNewsListScreen';
  const AddNewsListScreen({Key? key}) : super(key: key);

  @override
  _AddNewsListScreenState createState() => _AddNewsListScreenState();
}

class _AddNewsListScreenState extends State<AddNewsListScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  late final TextEditingController _titleController, _subtitleController;

  @override
  void initState() {
    _subtitleController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _subtitleController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? newsImages;
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
        final ref = FirebaseStorage.instance.ref().child('userImages').child('$_uuid.jpg');
        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        newsImages = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('news').doc(_uuid).set({
          'newsImages' : newsImages.toString(),
          'heading': _titleController.text,
          'subHeading': _subtitleController.text,
          'dateTime': Timestamp.now(),
        });
        clearFrom();
        Fluttertoast.showToast(
          msg: "News uploaded successfully",
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
    _subtitleController.clear();
    _titleController.clear();
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
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                  minLines: 1,
                                  maxLines: 2,
                                  keyboardType: TextInputType.multiline,
                                  controller: _subtitleController,
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
}