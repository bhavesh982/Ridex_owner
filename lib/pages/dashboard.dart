import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/pages/addSpaceship.dart';
import 'package:ridex_owner/pages/rideNotifications.dart';
import '../authentication/login_screen.dart';
import '../commons/common_methods.dart';
import '../global/global_var.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CommonMethods commonMethods = CommonMethods();
  Random random=Random();
  int otp=0;
  @override
  void initState() {
    
    User ?user=FirebaseAuth.instance.currentUser;
    DatabaseReference fref=FirebaseDatabase.instance.ref().child("owners").child(user!.uid);
   fref.once().then((value) {
     setState(() {
       spaceShipCompanyName=(value.snapshot.value as Map)["company"];
     });
   }

   );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(
          width: 255,
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  color: Colors.black,
                  height: 160,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                spaceShipCompanyName,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(onPressed:(){
                  FirebaseAuth.instance.signOut().whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (c)=>const LoginScreen())));
                }, child: const Text("Sign out"))
              ],
            ),
          ),
        ),
      floatingActionButton: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed:(){

                },
                child: const Icon(Icons.notifications_active),),
              const SizedBox(height: 10,),
              FloatingActionButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>const AddSpaceShip()));
                },
                child: const Icon(Icons.add),),
            ],
          )
        ],
      ),
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
                "Your Spaceships",
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
                defaultChild: const Center(child: LinearProgressIndicator()),
                query: FirebaseDatabase.instance
                    .ref()
                    .child("spaceships")
                    .child("company")
                    .child(spaceShipCompanyName),
                itemBuilder: (context, snapshot, animation, index) {
                  if (snapshot.key.toString() != "logo") {
                    return GestureDetector(
                      onTap: (){
                        User? user = FirebaseAuth.instance.currentUser;
                        setState(() {
                          uid=user!.uid;
                          spaceShipSelected=snapshot.key.toString();
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>const RideNotifications()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffe9e9e9),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          height: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 130,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  snapshot.child("image").value.toString(),
                                  placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                                  imageBuilder: (context, imageprovider) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          image: DecorationImage(
                                              image: imageprovider,
                                              fit: BoxFit.fill)),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text( snapshot.key.toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text("Seat : ${snapshot.child("seat").value.toString()} | Thrust : ${snapshot.child("thrust").value.toString()} | Type : ${snapshot.child("type").value.toString()}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black
                                            ),
                                          ),
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
                      ),
                    );

                    //oldListCard(snapshot, index, context);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ));
  }

  rideBookingOTP() async{
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context)=>LoadingDialog
    //       (messageText: "Confirming your ride"));
    // otp=random.nextInt(9999);
    // setState(() {
    //   generatedOtp=otp;
    // });
    // Map<String,Object> userDataMap={
    //   "otp" : otp
    // };
    // await userRefAuth.update(userDataMap).whenComplete(() => Navigator.pop(context));
    //Navigator.push(context, MaterialPageRoute(builder: (c) => const SeatSelection()));
  }
}
