import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../authentication/login_screen.dart';
import '../global/global_var.dart';

class UploadedContent extends StatefulWidget {
  const UploadedContent({super.key});

  @override
  State<UploadedContent> createState() => _UploadedContentState();
}

class _UploadedContentState extends State<UploadedContent> {
  get commonMethods => null;
  DatabaseReference databaseReference=FirebaseDatabase.instance.ref().child("owners");
  getOwnerInfoAndCheckBlockStatus()async{
    DatabaseReference databaseReference=FirebaseDatabase.instance.ref().child("owners").child(FirebaseAuth.instance.currentUser!.uid);
    await databaseReference.once().then((snap){
      if(snap.snapshot.value!=null){
        if((snap.snapshot.value as Map)["blockstatus"]=="no"){
          setState(() {
            userName=(snap.snapshot.value as Map)["name"];
          });
          if(!context.mounted) return;
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const UploadedContent()));
        }
        else{
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
          commonMethods.displaySnackBar("User Blocked", context);
        }
      }
      else{
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      appBar: AppBar(
        title: const Text("AppBar"),
      ),
      body: FirebaseAnimatedList(
          query: databaseReference,
          padding: const EdgeInsets.all(8.0),
          reverse: false,
          itemBuilder: (_, DataSnapshot snapshot,
              Animation animation, int x) {
            return ListTile(
              subtitle: Text(snapshot.value.toString()),
            );
          }
      ),
    );
  }
}
