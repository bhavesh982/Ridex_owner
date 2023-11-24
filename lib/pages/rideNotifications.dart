import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/commons/common_methods.dart';
import 'package:ridex_owner/pages/rideConfirmOTP.dart';

import '../global/global_var.dart';
import '../widgets/loading_dialog.dart';
class RideNotifications extends StatefulWidget {
  const RideNotifications({super.key});

  @override
  State<RideNotifications> createState() => _RideNotificationsState();
}

class _RideNotificationsState extends State<RideNotifications> {
  @override

  CommonMethods commonMethods=CommonMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            '',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: const Color(0xff103232),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lets go",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                defaultChild: const Center(child: LinearProgressIndicator()),
                query: FirebaseDatabase.instance
                    .ref()
                    .child("owners")
                    .child(uid)
                    .child("riderequest")
                    .child("dogaship"),
                itemBuilder: (context, snapshot, animation, index) {
                if(snapshot.child("status").value.toString().trim()!="rejected") {
                  return Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Container(
                     decoration: BoxDecoration(
                         color: const Color(0xffe9e9e9),
                         borderRadius: BorderRadius.circular(12)
                     ),
                     height: 200,
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text("yo"),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text( "Request No : ${snapshot.key.toString().toUpperCase()}",
                                       style: const TextStyle(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color: Colors.black),),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 8),
                                     child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                        Text("From : ${snapshot.child("loc").value.toString()}",style:
                                          const TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey
                                          ),),
                                         Text("To : ${snapshot.child("dest").value.toString()}",style:
                                         const TextStyle(
                                             fontSize: 20,
                                             color: Colors.grey
                                         ),),
                                         Text("Price : ${(snapshot.child("price").value as double).toStringAsFixed(2)}",style:
                                         const TextStyle(
                                             fontSize: 20,
                                             color: Colors.grey
                                         ),),
                                         Text("Distance : ${(snapshot.child("distance").value as double).toStringAsFixed(2)}",style:
                                         const TextStyle(
                                             fontSize: 20,
                                             color: Colors.grey
                                         ),)
                                       ],
                                     ),
                                   ),
                                   Row(
                                     children: [
                                       ElevatedButton(onPressed: ()async{
                                         await changeStatusToAccepted(snapshot);
                                         commonMethods.displaySnackBar(snapshot.key.toString(), context);
                                        Navigator.push(context, MaterialPageRoute(builder: (c)=>const RideConfirmOTP()));
                                       }, child: const Text("  Accept  ")),
                                       const SizedBox(width: 10,),
                                       ElevatedButton(onPressed: ()async{
                                         await changeStatusToRejected(snapshot);
                                         commonMethods.displaySnackBar(snapshot.key.toString(), context);
                                       }, child: const Text("  Reject  ")),
                                     ],
                                   )
                                 ],
                               ),
                             ),

                           ],
                         )
                         // columnDetails(snapshot, index, context)
                       ],
                     ),
                   ),
                 );
                }
                else{
                  return const SizedBox();
                }
                }
                ,
              ),
            ),
          ],
        ));
  }

  changeStatusToAccepted(DataSnapshot snapshot) async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Registering your account"));
   DatabaseReference dRef= FirebaseDatabase.instance
        .ref()
        .child("owners")
        .child(uid)
        .child("riderequest")
        .child(spaceShipSelected)
        .child(snapshot.key.toString());
   Map<String,Object> value={
     "status":"accepted"
   };
   await dRef.update(value).whenComplete(() => Navigator.pop(context));
  }
  changeStatusToRejected(DataSnapshot snapshot) async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Registering your account"));
    DatabaseReference dRef= FirebaseDatabase.instance
        .ref()
        .child("owners")
        .child(uid)
        .child("riderequest")
        .child(spaceShipSelected)
        .child(snapshot.key.toString());
    Map<String,Object> value={
      "status":"rejected"
    };
    await dRef.update(value).whenComplete(() => Navigator.pop(context));
  }
}

// Text("Destination : ${snapshot.child("dest").value.toString()}"
//   ,style: const TextStyle(
//       fontSize: 16,
//       color: Colors.black
//   ),
// ),
// Text("Location : ${snapshot.child("loc").value.toString()}"
//   ,style: const TextStyle(
//       fontSize: 16,
//       color: Colors.black
//   ),
// ),
// Text("Price : ${(snapshot.child("price").value as double).toStringAsFixed(2)}"
//   ,style: const TextStyle(
//       fontSize: 16,
//       color: Colors.black
//   ),
// ),
// Text("Distance : ${(snapshot.child("distance").value as double).toStringAsFixed(2)}"
//   ,style: const TextStyle(
//       fontSize: 16,
//       color: Colors.black
//   ),
// ),
