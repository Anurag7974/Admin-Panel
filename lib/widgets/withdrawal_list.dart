import 'package:admincontrol/consts/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'withdrawal_widget.dart';

class WithdrawalList extends StatelessWidget {
  const WithdrawalList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Withdrawal').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: isInDashboard && snapshot.data!.docs.length > 2 ? 2 : snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    WithdrawalWidget(
                                      accountName:  snapshot.data!.docs[index]['accountName'],
                                      bank:  snapshot.data!.docs[index]['bank'],
                                      branch:  snapshot.data!.docs[index]['branch'],
                                      ifsc:  snapshot.data!.docs[index]['ifsc'],
                                      account:  snapshot.data!.docs[index]['account'],
                                      amount:  snapshot.data!.docs[index]['amount'],
                                      city:  snapshot.data!.docs[index]['city'],
                                      userName:  snapshot.data!.docs[index]['userName'],
                                      userId:  snapshot.data!.docs[index]['userId'],
                                      withdrawalDate:  snapshot.data!.docs[index]['withdrawalDate'],
                                      withdrawalId:  snapshot.data!.docs[index]['withdrawalId'],
                                    ),
                                    const Divider(thickness: 3,)
                                  ],
                                );
                              }
                          ),
                        );
                      } else {
                        return  const Center(
                            child: Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text('Your store is empty'),
                            )
                        );
                      }
                    }   return const Center(
                      child: Text('Something went wrong',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                    );
                  });
            }
}