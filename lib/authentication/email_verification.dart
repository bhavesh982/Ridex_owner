import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/authentication/login_screen.dart';
import 'package:ridex_owner/commons/common_methods.dart';
import 'package:ridex_owner/global/global_var.dart';
import '../widgets/loading_dialog.dart';
class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  CommonMethods commonMethods= CommonMethods();
  checkemailVerified()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Verifying"));
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload().whenComplete(() => Navigator.pop(context));
    bool check = user!.emailVerified;
    if(check){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const  LoginScreen()));
    }
    else{
      await user.reload().whenComplete(() => Navigator.pop(context));
      commonMethods.displaySnackBar("Verify Email First", context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainTheme,
      ),
      backgroundColor: mainTheme,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonTheme
              ),
              onPressed: ()async{
                await checkemailVerified();
              },
              child: const Text("Verify"),
            ),
          ),
        ),
      ),
    );
  }
}
