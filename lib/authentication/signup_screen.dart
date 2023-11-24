import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridex_owner/authentication/email_verification.dart';
import 'package:ridex_owner/authentication/login_screen.dart';
import 'package:ridex_owner/commons/common_methods.dart';
import 'package:ridex_owner/global/global_var.dart';
import 'package:ridex_owner/widgets/loading_dialog.dart';
import 'dart:io';
import '../pages/addSpaceship.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

}


class _SignUpScreenState extends State<SignUpScreen> {
  //Text Editors

  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _companyNameController= TextEditingController();
  final TextEditingController _uPhoneController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  CommonMethods commonMethods= CommonMethods();
  XFile? imagefile;
  final ImagePicker _picker= ImagePicker();
  String timenow = DateTime.now().millisecondsSinceEpoch.toString();
  //Methods
  chooseImgGallery()async{
    final pickedfile=await _picker.pickImage(source: ImageSource.gallery);
    if(pickedfile!=null) {
      setState(() {
        imagefile=pickedfile;
      });
    }
  }
  uploadToStorage()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Uploading"));
    Reference firebaseDatabase = FirebaseStorage.instance.ref().child("models").child("${timenow}1");
    UploadTask task=firebaseDatabase.putFile(File(imagefile!.path));
    TaskSnapshot snapshot = await task;
    String imageURL= await snapshot.ref.getDownloadURL().whenComplete(() {
      Navigator.pop(context);
      createNewUser();
    });
    setState(() {
      imgURL=imageURL;
    });
  }

  checkInternetConnection() async {
  if(await commonMethods.checkConnectivity(context)){
    signUpFormValidation();
  }
  }
  signUpFormValidation(){
    if(_companyNameController.text.trim().length<3){
      commonMethods.displaySnackBar("User name must be greater than 4 ", context);
    }
    else if(_uPhoneController.text.trim().length!=10){
      commonMethods.displaySnackBar("Enter valid phone number ", context);
    }
    else if(!_emailController.text.trim().contains("@")){
      commonMethods.displaySnackBar("Enter valid email ", context);
    }
    else if(_passwordController.text.trim().length<6){
      commonMethods.displaySnackBar("Password must be at least 6 characters ", context);
    }
    else{
      uploadToStorage();
    }
  }
  createNewUser() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Registering your account"));
    final User? userFirebase=(
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim())
        .catchError((errorMsg){
      Navigator.pop(context);
      commonMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;
    if(!context.mounted) return;
    Navigator.pop(context);
    DatabaseReference userRef=FirebaseDatabase.instance.ref().child("owners").child(userFirebase!.uid);
    DatabaseReference locRef=FirebaseDatabase.instance.ref().child("spaceships").child("company");
    Map userDataMap={
      "uid" :  userFirebase.uid,
      "logo": imgURL,
      "company": _companyNameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _uPhoneController.text.trim(),
      "blockstatus": "no",
      "spaceships": ""
    };
    Map<String,Object> logo={
      "logo": imgURL
    };
    Map<String,Object> comp={
      _companyNameController.text.trim(): logo
    };
    locRef.update(comp);
    setState(() {
      spaceShipCompanyName= _companyNameController.text.trim();
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user!= null && !user.emailVerified) {
      userRef.set(userDataMap).whenComplete(() => Navigator.pop(context));
      await user.sendEmailVerification().whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (c)=>const  EmailVerification())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return signUpContent(context);
  }

  Scaffold signUpContent(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
              const SizedBox(
                height: 50,
              ),
            const Text("Create user account"),
            const SizedBox(
              height: 50,
            ),
            imagefile==null?
             Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 83,
                    backgroundImage: AssetImage("assets/avatarman.png"), backgroundColor: Color(0xff103232),
                  ),
                  IconButton(onPressed: (){
                    chooseImgGallery();
                  }, icon: const Icon(Icons.camera_alt))
                ],
              )
            ):Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: DecorationImage(
                      image: FileImage(
                        File(
                          imagefile!.path
                        )
                      )
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  chooseImgGallery();
                }, icon: const Icon(Icons.camera_alt))
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _companyNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Company Name"
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  TextField(
                    controller: _uPhoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Phone no."
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(onPressed: (){
                    checkInternetConnection();
                  }, child: const Text("SignUp")),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text("Already have an account ?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>const LoginScreen()));
                      }, child: const Text("Login here")),
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
