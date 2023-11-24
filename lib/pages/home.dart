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
  int value=0;
  final TextEditingController _modelNameController= TextEditingController();
  final TextEditingController _typeController= TextEditingController();
  final TextEditingController _seatsController= TextEditingController();
  final TextEditingController _thrustController= TextEditingController();
  final TextEditingController _baseController= TextEditingController();
  final TextEditingController _levelController= TextEditingController();
  final TextEditingController _rateController= TextEditingController();
  CommonMethods commonMethods= CommonMethods();
  XFile? imagefile1;
  final ImagePicker _picker1= ImagePicker();
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
  checkInternetConnection() async {
    if(await commonMethods.checkConnectivity(context)){
      if(imagefile1!=null){
        uploadToStorage();
      }
      else{
        commonMethods.displaySnackBar("Choose image first", context);
      }
    }
  }
  uploadToStorage()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)=>LoadingDialog
          (messageText: "Uploading"));

    Reference firebaseDatabase1 = FirebaseStorage.instance.ref().child("models").child(timenow);
    UploadTask task1=firebaseDatabase1.putFile(File(imagefile1!.path));
    task1.whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (c)=>const UploadedContent())));
    TaskSnapshot snapshot1 = await task1;
    String imageURL1= await snapshot1.ref.getDownloadURL();

    setState(() {
      imgURL1=imageURL1;
    });
    uploadToRealtimeDatabase();
  }
  uploadToRealtimeDatabase()async{
    Map<String,Object>val={
      "val":1
    };
    Map<String,Object> arrangements={
      (value+1).toString():"E",
      (value+2).toString():"E",
      (value+3).toString():"E",
      (value+4).toString():"E",
      (value+5).toString():"E",
      (value+6).toString():"E",
      (value+7).toString():"E",
      (value+8).toString():"E",
      (value+9).toString():"E",
      (value+10).toString():"E",
    };
    Map<String,Object> arrangements2={
      (value+11).toString():"E",
      (value+12).toString():"E",
      (value+13).toString():"E",
      (value+14).toString():"E",
      (value+15).toString():"E",
      (value+16).toString():"E",
      (value+17).toString():"E",
      (value+18).toString():"E",
      (value+19).toString():"E",
      (value+20).toString():"E",
    };
    Map<String,Object> seats={
      "E1":arrangements,
    };
    Map<String,Object> seats2={
      "E2":arrangements2,
    };
    seats.addAll(seats2);

    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef=FirebaseDatabase.instance.ref().child("owners").child(user!.uid).child("spaceships").child("company");
    Map<String,Object> shipMap={
      "base" : int.parse(_baseController.text.trim()),
      "image": imgURL1,
      "level": int.parse(_levelController.text.trim()),
      "mul": val,
      "rate": int.parse(_rateController.text.trim()),
      "seat": int.parse(_seatsController.text.trim()),
      "seats":seats,
      "type":_typeController.text.trim(),
      "thrust": int.parse(_thrustController.text.trim()),
    };
    Map<String,Object> name={
      _modelNameController.text.trim():shipMap
    };
      await userRef.update(name);
      /////////////////////////////////////////////////////////////////////////////
    DatabaseReference spaceshipl=FirebaseDatabase.instance.ref().child("spaceships").child("company").child(spaceShipCompanyName).child(_modelNameController.text.trim());
    Map<String,Object>vall={
      "val":1
    };
    Map<String,Object> arrangementsl={
      (value+1).toString():"E",
      (value+2).toString():"E",
      (value+3).toString():"E",
      (value+4).toString():"E",
      (value+5).toString():"E",
      (value+6).toString():"E",
      (value+7).toString():"E",
      (value+8).toString():"E",
      (value+9).toString():"E",
      (value+10).toString():"E",
    };
    Map<String,Object> seatsl={
      "E1":arrangementsl,
    };
    Map<String,Object> arrangementsl2={
      (value+11).toString():"E",
      (value+12).toString():"E",
      (value+13).toString():"E",
      (value+14).toString():"E",
      (value+15).toString():"E",
      (value+16).toString():"E",
      (value+17).toString():"E",
      (value+18).toString():"E",
      (value+19).toString():"E",
      (value+20).toString():"E",
    };
    Map<String,Object> seats2l={
      "E2":arrangementsl2,
    };
    seatsl.addAll(seats2l);

    Map<String,Object> SpaceshipMapl={
      "base" : _baseController.text.trim(),
      "image": imgURL1,
      "level": _levelController.text.trim(),
      "mul": vall,
      "rate": _rateController.text.trim(),
      "seat": _seatsController.text.trim(),
      "seats":seatsl,
      "type":_typeController.text.trim(),
      "thrust": _thrustController.text.trim(),
    };
    await spaceshipl.update(SpaceshipMapl);
  }
  @override
  void initState() {
    // TODO: implement initState
    User? user = FirebaseAuth.instance.currentUser;
    DatabaseReference databaseReference=FirebaseDatabase.instance.ref().child("owners").child(user!.uid);
    databaseReference.once().then((snap){
      setState(() {
        spaceShipCompanyName=(snap.snapshot.value as Map)["company"];
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //isLoggedIn();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          commonMethods.displaySnackBar(spaceShipCompanyName, context);
        },
      ),
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
            Padding(padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: _modelNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Model Name"
                    ),
                  ),
                  TextField(
                    controller: _baseController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Base Price per 1000 light years"
                    ),
                  ),
                  TextField(
                    controller: _levelController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Level of spaceship"
                    ),
                  ),
                  TextField(
                    controller: _rateController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Rate "
                    ),
                  ),
                  TextField(
                    controller: _seatsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "seats available (in multiple of 20)"
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
                    controller: _typeController,
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
