import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/authentication/login_screen.dart';
import 'package:ridex_owner/commons/common_methods.dart';
import '../pages/home.dart';
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
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=>const  LoginScreen()));
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
        title: Text("Verify"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            //await checkemailVerified();
            Navigator.push(context, MaterialPageRoute(builder: (c)=>const  LoginScreen()));
          },
          child: Text("Verify"),
        ),
      ),
    );
  }
}
