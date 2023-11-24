import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../commons/common_methods.dart';

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
              onCompleted: (pin) {
                commonMethods.displaySnackBar(pin, context);
              },
            ),
          ),
          const SizedBox(height: 150,)
        ],
      ),
    );
  }
}
