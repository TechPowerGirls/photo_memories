import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AddPhoto.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Ref = Firestore.instance.collection("photos");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,


      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text("Photo Memories"),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (_)=>AddWord()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: Ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  VxSwiper.builder(
                    itemCount: snapshot.data.documents.length,
                    viewportFraction: 0.98,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayCurve: Curves.easeInToLinear,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 10),
                    height: context.screenHeight*0.85,
                    itemBuilder: (context, index) {
                      return VxBox(
                        child: Stack(
                          children: [

                            Card(
                                child: Image.network(snapshot.data.documents[index].data['photoImg'],height: 300,width:context.screenWidth,fit: BoxFit.cover,)
                            ).rotate(-2.0).pOnly(top: 45,bottom: 20),
                            //Icon(Icons.favorite,size:40,color: Colors.red,).pOnly(top:2,left: 280).rotate(25.0),
                            Icon(Icons.favorite,size:30,color: Colors.red,).pOnly(top:10,).rotate(-25.0),
                            VxBox().yellow100.shadowXl.p8.make().capsule().h(40).w(100).opacity50().rotate(25.0).pOnly(top:10,left: 280),
                            VxBox().yellow100.shadowSm.p8.make().capsule().h(40).w(120).opacity50().rotate(25.0).pOnly(top: 318),
                            Text(snapshot.data.documents[index].data['photoTitle']).text.xl5.fontFamily('GreatVibes').make().pOnly(left: 50,top: 0),

                            Text(snapshot.data.documents[index].data['photoMemory'],).text.xl4.fontFamily('GreatVibes').make().box.yellow100.p8.make().rotate0().pOnly(top: 360).rotate(-3.0),
                          ],
                        ).scrollVertical(),
                      ).white.shadowSm.p16.make().p16();
                    },
                  ).py4(),
                ],
              ).scrollVertical();
            } else {
              return CircularProgressIndicator();
            }


          }),
    );
  }
}
