import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global/global_var.dart';
import '../widgets/loading_dialog.dart';
class RideFinish extends StatefulWidget {
  const RideFinish({super.key});

  @override
  State<RideFinish> createState() => _RideFinishState();
}

class _RideFinishState extends State<RideFinish> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainTheme,
        ),
        backgroundColor: mainTheme,
        body: Container(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text("Ride Finished ?",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  const SizedBox(height: 20,),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text("Make sure to drive sober "),
                  ),
                  const SizedBox(height: 300,),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:buttonTheme
                          ),
                            onPressed: (){
                          showDialog(context: context, builder: (c)=>AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text("are you sure you want to end the ride..."),
                            actions: [
                              TextButton(onPressed: (){
                                finishRide();
                              }, child: const Text("Yes")),
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: const Text("Cancel"))
                            ],
                          ));
                        }, child: const Text("Finish")),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ) ,
        )
    );
  }

  finishRide() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Ending ride"));
    DatabaseReference dRef= FirebaseDatabase.instance
        .ref()
        .child("owners")
        .child(uid)
        .child("riderequest")
        .child(spaceShipSelected)
        .child(userUID);
    Map<String,Object> value={
      "status":"finished"
    };
    await dRef.update(value).whenComplete(() {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const RideFinish()));
    });
  }
}