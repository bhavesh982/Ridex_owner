import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:ridex_owner/pages/rideDashboard.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff103232),
      appBar: AppBar(
        backgroundColor: const Color(0xff103232),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40,left: 40),
            child: ListTile(
              title: Text("Secret code!",style: TextStyle(
                  fontSize: 22
              ),),
              subtitle: Text("for your journey."),
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
              onCompleted: (pin) async{
               await matchTheOTP();
               if(pin==generatedOTP.toString().trim()){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const RideDashboard()));
               }
              },
            ),
          ),
          const SizedBox(height: 150,)
        ],
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
}
