import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridex_owner/authentication/login_screen.dart';
import 'package:ridex_owner/global/global_var.dart';
import 'package:ridex_owner/pages/uploaded_content.dart';

import '../commons/common_methods.dart';
import '../widgets/loading_dialog.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _typesController= TextEditingController();
  final TextEditingController _seatsController= TextEditingController();
  final TextEditingController _thrustController= TextEditingController();
  CommonMethods commonMethods= CommonMethods();
  XFile? imagefile1;
  XFile? imagefile2;
  XFile? imagefile3;
  final ImagePicker _picker1= ImagePicker();
  final ImagePicker _picker2= ImagePicker();
  final ImagePicker _picker3= ImagePicker();
  String timenow = DateTime.now().millisecondsSinceEpoch.toString();
  //Methods

  chooseImgGallery1()async{
    final pickedfile1=await _picker1.pickImage(source: ImageSource.gallery);
    if(pickedfile1!=null) {
      setState(() {
        imagefile1=pickedfile1;
      });
    }
    }
  chooseImgGallery2()async{
    final pickedfile2=await _picker2.pickImage(source: ImageSource.gallery);
    if(pickedfile2!=null) {
      setState(() {
        imagefile2=pickedfile2;
      });
    }
  }
  chooseImgGallery3()async{
    final pickedfile3=await _picker3.pickImage(source: ImageSource.gallery);
    if(pickedfile3!=null) {
      setState(() {
        imagefile3=pickedfile3;
      });
    }
  }
  checkInternetConnection() async {
    if(await commonMethods.checkConnectivity(context)){
      if(imagefile1!=null){
        uploadToStorage();
      }
      else{
        commonMethods.displaySnackBar("Choose image 1 first", context);
      }
      if(imagefile2!=null){
        uploadToStorage();
      }
      else{
        commonMethods.displaySnackBar("Choose image 2 first", context);
      }
      if(imagefile3!=null){
        uploadToStorage();
      }
      else{
        commonMethods.displaySnackBar("Choose image 3 first", context);
      }
    }
  }
  uploadToStorage()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Uploading"));

    Reference firebaseDatabase1 = FirebaseStorage.instance.ref().child("models").child("${timenow}1");
    UploadTask task1=firebaseDatabase1.putFile(File(imagefile1!.path));
    task1.whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (c)=>const UploadedContent())));
    TaskSnapshot snapshot1 = await task1;
    String imageURL1= await snapshot1.ref.getDownloadURL();

    Reference firebaseDatabase2 = FirebaseStorage.instance.ref().child("models").child("${timenow}2");
    UploadTask task2=firebaseDatabase2.putFile(File(imagefile2!.path));
    TaskSnapshot snapshot2 = await task2;
    String imageURL2= await snapshot2.ref.getDownloadURL();

    Reference firebaseDatabase3 = FirebaseStorage.instance.ref().child("models").child("${timenow}3");
    UploadTask task3=firebaseDatabase3.putFile(File(imagefile3!.path));
    TaskSnapshot snapshot3 = await task3;
    String imageURL3= await snapshot3.ref.getDownloadURL();
    setState(() {
      imgURL1=imageURL1;
      imgURL2=imageURL2;
      imgURL3=imageURL3;
    });
    uploadToRealtimeDatabase();
  }
  uploadToRealtimeDatabase()async{
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef=FirebaseDatabase.instance.ref().child("owners").child(user!.uid).child("spaceship");
    Map images={
      "img1" : imgURL1,
      "img2" : imgURL2,
      "img3" : imgURL3,
    };
    Map userDataMap={
      "uid" :  user.uid,
      "images" : images,
      "name": _typesController.text.trim(),
      "email": _nameController.text.trim(),
      "phone": _seatsController.text.trim(),
      "blockstatus": "no",
    };

      await userRef.set(userDataMap);
  }
  @override
  Widget build(BuildContext context) {
    //isLoggedIn();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200,),
            imagefile1==null?
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 83,
                      backgroundImage: AssetImage("assets/avatarman.png"),
                    ),
                    IconButton(onPressed: (){
                      chooseImgGallery1();
                    }, icon: const Icon(Icons.camera_alt))
                  ],
                )
            ):Center(
              child: Column(
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
                                  imagefile1!.path
                              )
                          )
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    chooseImgGallery1();
                  }, icon: const Icon(Icons.camera_alt))
                ],
              ),
            ),
            imagefile2==null?
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 83,
                      backgroundImage: AssetImage("assets/avatarman.png"),
                    ),
                    IconButton(onPressed: (){
                      chooseImgGallery2();
                    }, icon: const Icon(Icons.camera_alt))
                  ],
                )
            ):Center(
              child: Column(
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
                                  imagefile2!.path
                              )
                          )
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    chooseImgGallery2();
                  }, icon: const Icon(Icons.camera_alt))
                ],
              ),
            ),
            imagefile3==null?
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 83,
                      backgroundImage: AssetImage("assets/avatarman.png"),
                    ),
                    IconButton(onPressed: (){
                      chooseImgGallery3();
                    }, icon: const Icon(Icons.camera_alt))
                  ],
                )
            ):Center(
              child: Column(
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
                                  imagefile3!.path
                              )
                          )
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    chooseImgGallery3();
                  }, icon: const Icon(Icons.camera_alt))
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Name"
                    ),
                  ),
                  TextField(
                    controller: _thrustController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Thrust"
                    ),
                  ),
                  TextField(
                    controller: _seatsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "seat"
                    ),
                  ),
                  TextField(
                    controller: _typesController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "type"
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: (){
              checkInternetConnection();
            }, child: const Text(
              "Click"
            )),
            const SizedBox(
              height: 20,
            ),
            TextButton(onPressed: (){
              signout();
            }, child: Text("Signout"))
          ],
        ),
      )
    );
  }
  signout()async{
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
  }
isLoggedIn()async{
    User? user= FirebaseAuth.instance.currentUser;
    if(user==null){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
    }
}
}
