import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ridex_owner/authentication/signup_screen.dart';
import 'package:ridex_owner/global/global_var.dart';
import 'package:ridex_owner/pages/home.dart';
import 'package:ridex_owner/pages/uploaded_content.dart';
import '../commons/common_methods.dart';
import '../widgets/loading_dialog.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  CommonMethods commonMethods= CommonMethods();

  checkInternetConnection() async {
    if(await commonMethods.checkConnectivity(context)){
      loginFormValidation();
    }
  }
  loginFormValidation(){
     if(!_emailController.text.trim().contains("@")){
      commonMethods.displaySnackBar("Enter valid email ", context);
    }
    else if(_passwordController.text.trim().length<6){
      commonMethods.displaySnackBar("Password must be at least 6 characters ", context);
    }
    else{
      loginUser();
    }
  }
  loginUser()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Logging in"));
    final User? userFirebase=(
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
            .catchError((errorMsg){
          Navigator.pop(context);
          commonMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;
    if(userFirebase!=null){
      DatabaseReference databaseReference=FirebaseDatabase.instance.ref().child("owners").child(userFirebase.uid);
      databaseReference.once().then((snap){
        if(snap.snapshot.value!=null){
          if((snap.snapshot.value as Map)["blockstatus"]=="no"){
            // userName=(snap.snapshot.value as Map)["name"];
            if(!context.mounted) return;
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=>const UploadedContent()));
          }
          else{
            FirebaseAuth.instance.signOut();
            commonMethods.displaySnackBar("User Blocked", context);
          }
        }
        else{
          FirebaseAuth.instance.signOut();
          commonMethods.displaySnackBar("Permission denied :Not Customer credentials", context);
        }
      });
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Image.asset("assets/logo.png",
                  scale: 2,),
              ),
              const Text("Login User"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "email"
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                          labelText: "password"
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(onPressed: (){
                      checkInternetConnection();
                    }, child: const Text("Login")),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Don't have an account ?"),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>const SignUpScreen()));
                        }, child: const Text("Create here")),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

