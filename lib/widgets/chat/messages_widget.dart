import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("chat").snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (chatSnapshot.data == null) {
          print('no data loaded');
          return Center(
            child: Container(),
          );
        }
        return Container(
          child: ListView.builder(
            itemCount: chatSnapshot.data?.docs.length,
            itemBuilder: (context, index) =>
                Text(chatSnapshot.data?.docs[index]['text']),
          ),
        );
      },
    );
  }
}
