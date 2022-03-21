import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  bool isConnected = false;
  String collectionPath = 'chats/NwC82NLL2WPoxO48FGZc/messages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collectionPath)
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            isConnected = false;
          } else {
            isConnected = true;
          }
          final documents = streamSnapshot.data?.docs;
          return isConnected
              ? ListView.builder(
                  itemCount: streamSnapshot.data?.docs.length,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(8),
                    child: Text(documents![index]['text']),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
         FirebaseFirestore.instance.collection(collectionPath).add({
           //add data as Map
           'text':'This was added by clicking + button'

         });
        },
      ),
    );
  }
}
