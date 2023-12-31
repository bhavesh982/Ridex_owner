import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:ridex_owner/pages/dashboard.dart';
import 'package:ridex_owner/pages/rideDashboard.dart';
import 'package:ridex_owner/pages/rideFinish.dart';

import '../commons/common_methods.dart';
import '../global/global_var.dart';
import '../widgets/loading_dialog.dart';

class RideConfirmOTP extends StatefulWidget {
  const RideConfirmOTP({super.key});
  @override
  State<RideConfirmOTP> createState() => _RideConfirmOTPState();
}
class _RideConfirmOTPState extends State<RideConfirmOTP> {
  CommonMethods commonMethods=CommonMethods();
  OtpFieldController controller=OtpFieldController();
  var eventSnap;
  @override
  void initState() {
    User? user=FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    DatabaseReference dref=FirebaseDatabase.instance.ref().child("owners").child(user!.uid).child("riderequest").child(spaceShipSelected).child(userUID);
    dref.onValue.listen((event) {
      setState(() {
        eventSnap=(event.snapshot.value as Map)["status"];
      });
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff103232),
      appBar: AppBar(
        backgroundColor: const Color(0xff103232),
      ),
      body: eventSnap!=null?Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40,left: 40),
              child: ListTile(
                title: const Text("Secret code!",style: TextStyle(
                    fontSize: 22
                ),),
                subtitle: Text("for your journey. ${eventSnap.toString()}"),
              ),
            ),
            SizedBox(
              height: 100,
              width: 300,
              child: OTPTextField(
                controller: controller,
                otpFieldStyle: OtpFieldStyle(
                    backgroundColor: const Color(0xff0A7F7F),
                    borderColor: Colors.transparent
                ),
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white
                ),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onChanged: (pin) async{
                  await matchTheOTP();
                  if(pin==generatedOTP.toString().trim()){
                    changeStatusToConfirmed();
                  }
                },
              ),
            ),
            const SizedBox(height: 150,)
          ],
        ),
      ):const Center(
        child: Text("User Cancelled Ride"),
      ),

    );
  }

  matchTheOTP() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Generating otp"));
    DatabaseReference dRef= FirebaseDatabase.instance
        .ref()
        .child("owners")
        .child(uid)
        .child("riderequest")
        .child(spaceShipSelected)
        .child(userUID)
        .child("otp");
    await dRef.once().then((value) {
      generatedOTP=value.snapshot.value as int;
    }).whenComplete(() => Navigator.pop(context));
  }
  changeStatusToConfirmed() async {
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
        .child(userUID);
    Map<String,Object> value={
      "status":"confirmed"
    };
    await dRef.update(value).whenComplete(() {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const RideFinish()));
    });
  }
}