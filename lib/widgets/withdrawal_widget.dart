

import 'package:admincontrol/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/utils.dart';

class WithdrawalWidget extends StatefulWidget {
  const WithdrawalWidget({Key? key,
    required this.account,
    required this.accountName,
    required this.amount,
    required this.userId,
    required this.bank,
    required this.userName,
    required this.branch,
    required this.ifsc,
    required this.withdrawalDate,
    required this.withdrawalId,
    required this.city}) : super(key: key);
  final String account, accountName, amount, bank, branch, city, ifsc, userId, userName, withdrawalId;
  final Timestamp withdrawalDate;

  @override
  _WithdrawaState createState() => _WithdrawaState();

}

class _WithdrawaState extends State<WithdrawalWidget> {
  late String withdrawalDateStr;
  @override
  void initState(){
    var postDate = widget.withdrawalDate.toDate();
    withdrawalDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(text: 'Account Name: ${widget.accountName}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'Bank: ${widget.bank}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'Branch: ${widget.branch}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'IFSC: ${widget.ifsc}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'Account: ${widget.account}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'Amount: ${widget.amount}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'City: ${widget.city}', color: color, textSize: 16, isTitle: true,),
                        const SizedBox(height: 5,),
                        TextWidget(text: 'UserName: ${widget.userName} ', color: color, textSize: 14, isTitle: true),
                        const SizedBox(height: 10,),
                        Text('UserID: ${widget.userId}'),
                         Text(withdrawalDateStr),
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}