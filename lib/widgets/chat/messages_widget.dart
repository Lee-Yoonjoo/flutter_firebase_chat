import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat/widgets/chat/message_bubble_widget.dart';

/* Here return FutureBuilder and ListView.builder both are working this way.
        * Like on the Udemy course, future : FirebaseAuth.instance.currentUser() gives an error null check required.
        * So I wrapped it with Future.value (https://stackoverflow.com/questions/66164073/user-cant-be-assigned-to-the-parameter-type-futureuser-in-futurebuilder) */

/*But I did not know how to get uid from futureSnapshot
        * I just called FirebaseAuth.instance.currentUser.uid right away. It worked so I even tried without wrapping with FutureBuilder. And it works without FutureBuilder.
        * Question 1 : Why FutureBuilder is used by the teacher? What for?
        * Question 2 : How can I get uid info from */
class MessagesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        User? user = futureSnapshot.data as User?;

        /* HOW TO GET uid FROM FirebaseAuth.instance.currentUser */
        // on FutureBuilder "future" wrap User as a Future with Future.value
        // because Type of FirebaseAuth.instance.currentUser is User and FutureBuilder's future type is Object. FutureBuilder Default data Type is <Object>
        // Method 1 without <User> next to FutureBuilder, declare User by casting futureSnapsho.data as User?.
        // Method 2 Use FutureBuilder<User> so you can call data easier.
        // Method 3 Without FutureBuilder call FirebaseAuth.instance.currentUser.

        User? u2 = FirebaseAuth.instance.currentUser;
        print("Future -- ${futureSnapshot.data}");
        print("Object -- ${FirebaseAuth.instance.currentUser}");

        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (chatSnapshot.data == null) {
                print('no data loaded');
                return Center(
                  child: Container(),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: chatSnapshot.data?.docs.length,
                itemBuilder: (context, index) => MessageBubbleWidget(
                  chatSnapshot.data?.docs[index]['text'],
                  chatSnapshot.data?.docs[index]['uid'] ==
                      futureSnapshot.data!.uid,
                 // on Udemy course He added this key to make sure but it works without it. Need to know why.
                 // key: ValueKey(chatSnapshot.data?.docs[index].id),
                ),
              );
              print(FirebaseAuth.instance.currentUser);
            });

        /*
         ListView.builder(
          reverse: true,
          itemCount: chatSnapshot.data?.docs.length,
          itemBuilder: (context, index) =>
              MessageBubbleWidget(chatSnapshot.data?.docs[index]['text'], chatSnapshot.data?.docs[index]['uid'] == FirebaseAuth.instance.currentUser!.uid),
        );*/
      },
    );
  }
}

/* If we have FutureBuilder here instead of that stream builder, which means for every new message we got on the back end, I would fetch all the data for the current user again and again.
* According to Videos. The list view is blinking when the new message is added. This means all data was recalled.
* That is a bit redundant, creating that new future and waiting for it to resolve on every new message*/

/*
Under FutureBuilder,
Check if the futures snapshot connection status waiting, so let's add this here. And if it's not waiting, I'll return to StreamBuilder. And down there.

We returned a ListView.builder again, but now that's instead of the stream builder,
 so I simply swapped Stream Builder and future builder to make sure that we don't create a new future just because something changed in our stream of data,
 which is coming from the Firebase Store collection. */
