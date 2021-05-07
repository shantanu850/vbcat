import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/footer.dart';

class Services extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Our Services",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/images/about1.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Weather it'a canapes party, drinks reception buffet or any private function, we tailor our menus to suit you.",
              textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontFamily: 'proxima'),),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("We love to get innovative with a personal touch",
              textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontFamily: 'proxima'),),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/images/about2.jpeg'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.amber,
        child:Icon(CupertinoIcons.chat_bubble_2_fill,color: Colors.black,),
      ),
      bottomNavigationBar: Container(height:90,child: FooterVB()),
    );
  }
}
