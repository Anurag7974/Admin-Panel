import 'package:admincontrol/widgets/side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../inner_screen/add_banners.dart';
import '../inner_screen/add_news_list.dart';
import '../inner_screen/add_prod.dart';
import '../inner_screen/add_tasks.dart';
import '../responsive.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/withdrawal_list.dart';
import '../widgets/products_widget.dart';
import '../widgets/text_widget.dart';


class DeshboardScreen extends StatelessWidget {
  const DeshboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    return SafeArea(
      key: context.read<menuController>().getScaffoldKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(fct: () {
              context.read<menuController>().controlDashboarkMenu;
            }, title: 'Dashboard',),
            const SizedBox(height: 20,),
            TextWidget(text: 'Latest Products', color: color),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {
                        GlobalMethods.navigateTo(ctx: context, routeName: UploadBannersForm.routeName);
                      },
                      text: 'Add Banners',
                      icon: Icons.store, backgroundColor: Colors.orangeAccent),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        GlobalMethods.navigateTo(ctx: context, routeName: UploadProductForm.routeName);
                      },
                      text: 'Add product',
                      icon: Icons.add, backgroundColor: Colors.orangeAccent),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        GlobalMethods.navigateTo(ctx: context, routeName: AddNewsListScreen.routeName);
                      },
                      text: 'Add NewsList',
                      icon: Icons.book_outlined, backgroundColor: Colors.orangeAccent),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        GlobalMethods.navigateTo(ctx: context, routeName: AddTasksScreen.routeName);
                      },
                      text: 'Add Tasks',
                      icon: Icons.apps, backgroundColor: Colors.orangeAccent),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            const SizedBox(height: defaultPadding,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                    child: Column(
                      children: [
                        Responsive(
                          mobile: ProductGrid(
                            childAspectRatio: size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                            crossAxisCount: size.width < 650 ? 2 : 4,
                          ),
                          desktop: ProductGrid(
                            childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          ),
                        ),
                          const WithdrawalList(),
                      ],
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}