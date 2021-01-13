import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:velocity_x/velocity_x.dart';


class AddWord extends StatefulWidget {

  //AddWord({Key key, this.setName, this.setId}) : super(key: key);




  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  String i;

  TextEditingController set_descriptionController = TextEditingController();
  TextEditingController set_imageController = TextEditingController();
  TextEditingController set_NameController = TextEditingController();
  _buildTextField(
      TextEditingController controller, String labelText) {
    return VxBox(
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),

            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    ).red600.roundedSM.make();
  }
  Map<String,dynamic> productToAdd;
  CollectionReference collectionReference = Firestore.instance.collection("photos");
  addProduct(){
    productToAdd={
      "photoMemory":set_descriptionController.text,
      "photoTitle":set_NameController.text,
      "photoImg":i,



    };
    collectionReference.add(productToAdd).whenComplete(() => print("added to the database"));
  }
  final Ref = Firestore.instance.collection("photos");

  File _image;
  bool _isLoading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile!= null) {
        _image = File(pickedFile.path);
      } else {
        CircularProgressIndicator();
      }
    });
  }

  uploadImage()async{
    if (_image!=null){
      StorageReference firebaseStorageRef=FirebaseStorage.instance.ref().child("photos")
          .child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task =firebaseStorageRef.putFile(_image);

      var downloadUrl = await(await task.onComplete).ref.getDownloadURL();
      print(downloadUrl);
      i = downloadUrl;

    }else{

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,


      ),
      floatingActionButton: new FloatingActionButton(

        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: (){
                          getImage();
                        },
                        child:_isLoading? Container(
                          child: CircularProgressIndicator(),
                        ):VxBox(
                          child:_image!=null?Image.file(_image,fit: BoxFit.cover,):Icon(Icons.image,color: Colors.white,),

                        ).height(200).width(context.screenWidth).red600.roundedSM.makeCentered().p16(),
                      ),
                      FlatButton(onPressed: (){
                        uploadImage();
                      },
                          child: Text("upload Iamge")),
                      SizedBox(height: 30,),
                      _buildTextField(set_descriptionController, 'photoMemory'),
                      SizedBox(height: 10,),
                      _buildTextField(set_NameController, 'photoTitle'),
                      // SizedBox(height: 10,),
                      //_buildTextField(set_imageController, 'image'),
                      SizedBox(height: 10,),
                      SizedBox(height: 10,),
                      SizedBox(height: 10,),
                      FlatButton(
                        onPressed: (){
                          addProduct();
                          Navigator.pop(context);
                        },
                        child: VxBox(
                          child: Center(child: Text("Add Photo Memory",style: TextStyle(
                            color: Colors.white,
                          ),)),
                        ).red600.height(60).width(context.screenWidth*0.6).roundedSM.make(),
                      ),
                    ],
                  ),
                ),
              ),


            ),
          );
        },
        child: Icon(Icons.camera_alt,color: Colors.red,),//Icon(Icons.chat),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: Ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData){
              return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context,index){
                    return Stack(
                      children: [
                        VxBox(
                            child: Column(
                              children: [
                                Card(
                                    child: Image.network(snapshot.data.documents[index].data['photoImg'],width:context.screenWidth,height: 150,fit: BoxFit.cover,)
                                ),
                                Text(snapshot.data.documents[index].data['photoTitle']).text.xl.fontFamily('GreatVibes').make(),
                              ],
                            )).white.p4.make().p8(),
                        InkWell(
                          onTap: (){
                            snapshot.data.documents[index].reference.delete();

                          },
                          child: VxBox(
                              child: Icon(Icons.clear,color: Colors.white,)
                          ).roundedFull.red500.make().p4(),
                        ),
                      ],
                    );
                  });
            }else {
              return Text('loading');
            }
          }


      ),
    );
  }
}
