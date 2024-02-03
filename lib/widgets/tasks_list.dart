import 'package:admincontrol/widgets/tasks_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/constants.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
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
                              itemCount: isInDashboard && snapshot.data!.docs.length > 4 ? 4 : snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    TasksWidget(
                                      heading:  snapshot.data!.docs[index]['heading'],
                                      deadLine:  snapshot.data!.docs[index]['deadLine'],
                                      subHeading:  snapshot.data!.docs[index]['subHeading'],
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