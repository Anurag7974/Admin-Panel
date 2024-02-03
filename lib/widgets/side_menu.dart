import 'package:admincontrol/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../inner_screen/all_news_list.dart';
import '../inner_screen/all_withdrawal_screen.dart';
import '../inner_screen/all_products.dart';
import '../inner_screen/all_tasks_list.dart';
import '../providers/dark_theme_provider.dart';
import '../screens/main_screen.dart';
import '../services/utils.dart';
import 'news_list.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SideMenuState();

}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);

    final color = Utils(context).color;
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(
          //   child:  Image.asset("assets/iamges/icon.png"),
          //   // Image.asset("assets/icon.png"),
          // ),
          const SizedBox(height: 10,),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(title: "View all products",
              press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllProductsScreen()));
              },
              icon: Icons.store),
          DrawerListTile(title: "View all withdrawal", press: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllOdersScreen()));
          }, icon: IconlyBold.bag2),
          DrawerListTile(title: "View all news", press: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllNewsScreen()));
          }, icon: Icons.book_outlined),
          DrawerListTile(title: "View all tasks", press: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllTasksScreen()));
          }, icon: Icons.apps),
          SwitchListTile(
            title: const Text("Theme"),
            secondary: Icon(themeState.getDarkTheme ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            value: theme,
            onChanged: (value) {
              setState(() {
                themeState.setDarkTheme = value;
              });
            },
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
//    For selecting those three line once press "Command+D
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return  ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icon, size: 18,),
      title: TextWidget(text: title, color: color),
    );
  }

}