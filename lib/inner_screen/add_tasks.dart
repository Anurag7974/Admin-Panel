import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/loading_manager.dart';
import '../widgets/text_widget.dart';

class AddTasksScreen extends StatefulWidget {
  static const routeName = '/AddTasksScreen';
  const AddTasksScreen({Key? key}) : super(key: key);

  @override
  _AddTasksScreenState createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController, _subtitleController, _deadlineController;

  @override
  void initState() {
    _subtitleController = TextEditingController();
    _titleController = TextEditingController();
    _deadlineController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _subtitleController.dispose();
    _titleController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? newsImages;
    if (isValid) {
      final _uuid = const Uuid().v4();
      try {
        // Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        await FirebaseFirestore.instance.collection('tasks').doc(_uuid).set({
          'heading': _titleController.text,
          'subHeading': _subtitleController.text,
          'deadLine': _deadlineController.text,
        });
        clearFrom();
        Fluttertoast.showToast(
          msg: "Tasks uploaded successfully",
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
    _deadlineController.clear();
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
                                  minLines: 5,
                                  maxLines: 10,
                                  keyboardType: TextInputType.multiline,
                                  controller: _subtitleController,
                                  key: const ValueKey('description'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration,
                                ),
                                const SizedBox(height: 20,),
                                TextWidget(text: 'DeadLine', color: color, isTitle: true),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  controller: _deadlineController,
                                  key: const ValueKey('deadline'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a deadline';
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration,
                                ),
                                const SizedBox(height: 20,),
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
}