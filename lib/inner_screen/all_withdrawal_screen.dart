import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/header.dart';
import '../widgets/withdrawal_list.dart';
import '../widgets/products_widget.dart';
import '../widgets/side_menu.dart';

class AllOdersScreen extends StatefulWidget{
  const AllOdersScreen({Key?key}) : super(key: key);

  @override
  State<AllOdersScreen> createState() => _AllOdersScreenState();
}

class _AllOdersScreenState extends State<AllOdersScreen>{
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<menuController>().getOrdersScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  We want this side menu only for large screen
            if(Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              //It takes 5/6 part of the screen
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(height: 25,),
                    Header(fct: () {
                      context.read<menuController>().controlAllOrder();
                    }, title: 'All Withdrawal',),
                    const SizedBox(height: 20,),
                     const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:  WithdrawalList(
                          isInDashboard: false,
                      ),
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