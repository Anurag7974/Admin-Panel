import 'dart:io';
import 'dart:typed_data';

import 'package:admincontrol/widgets/loading_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../responsive.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class UploadBannersForm extends StatefulWidget {
  static const routeName = '/UploadBannersForm';
  const UploadBannersForm({Key? key}) : super(key: key);
  @override
  _UploadBannersFormState createState() => _UploadBannersFormState();

}
class _UploadBannersFormState extends State<UploadBannersForm> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isLoading = false;

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Please pick up an image', context: context);
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
        imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('banners').doc(_uuid).set({
          'id': _uuid,
          'imageUrl': imageUrl.toString(),
        });
        clearFrom();
        Fluttertoast.showToast(
          msg: "Banners uploaded successfully",
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

  void clearFrom() {
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: size.width > 550 ? 750 : size.width * 0.354,
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              height: size.width > 650 ? 350 : size.width * 0.145 ,
                              width: size.width > 450 ? 650 : size.width * 0.254,
                              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: _pickedImage == null ? dottedBorder(color: color) : ClipRRect(borderRadius: BorderRadius.circular(12),
                                child: kIsWeb ? Image.memory(
                                  webImage, fit: BoxFit.fill,) :
                                Image.file(_pickedImage!, fit: BoxFit.fill,),)
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dottedBorder({
    required Color color,
  }) {
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
              },
                  child: TextWidget(
                    text: 'Choose an image', color: Colors.orangeAccent,))
            ],),
        ),
      ),
    );
  }

  Future <void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
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
}
