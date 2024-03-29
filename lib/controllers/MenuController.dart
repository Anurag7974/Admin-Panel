import 'package:flutter/material.dart';

class menuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _ordersScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _newsScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _tasksScaffoldKey = GlobalKey<ScaffoldState>();
  // Getters
  GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;
  GlobalKey<ScaffoldState> get getgridscaffoldKey => _gridScaffoldKey;
  GlobalKey<ScaffoldState> get getAddProductscaffoldKey => _addProductScaffoldKey;
  GlobalKey<ScaffoldState> get getOrdersScaffoldKey => _ordersScaffoldKey;
  GlobalKey<ScaffoldState> get getNewsScaffoldKey => _newsScaffoldKey;
  GlobalKey<ScaffoldState> get getTasksScaffoldKey => _tasksScaffoldKey;

  // Callbacks
  void controlDashboarkMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlProductsMenu() {
    if (!_gridScaffoldKey.currentState!.isDrawerOpen) {
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductsMenu() {
    if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllOrder() {
    if (!_ordersScaffoldKey.currentState!.isDrawerOpen) {
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllNews() {
    if (!_newsScaffoldKey.currentState!.isDrawerOpen) {
      _newsScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllTasks() {
    if (!_tasksScaffoldKey.currentState!.isDrawerOpen) {
      _tasksScaffoldKey.currentState!.openDrawer();
    }
  }
}