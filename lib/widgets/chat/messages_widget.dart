import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat/widgets/chat/message_bubble_widget.dart';

class MessagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("chat").orderBy('timestamp', descending: true).snapshots(),
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
            reverse: true,
            itemCount: chatSnapshot.data?.docs.length,
            itemBuilder: (context, index) =>
                MessageBubbleWidget(chatSnapshot.data?.docs[index]['text']),
          ),
        );
      },
    );
  }
}
