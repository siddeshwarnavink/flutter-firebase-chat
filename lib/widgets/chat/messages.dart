import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnap) {
        if (futureSnap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatSnap) {
            if (chatSnap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final chatDocs = chatSnap.data.documents;

            return ListView.builder(
              itemBuilder: (ctx, i) {
                return MessageBubble(
                    chatDocs[i]['text'],
                    futureSnap.data.uid == chatDocs[i]['userId'],
                    chatDocs[i]['username'],
                    chatDocs[i]['userImage'],);
              },
              itemCount: chatDocs.length,
              reverse: true,
            );
          },
        );
      },
    );
  }
}
