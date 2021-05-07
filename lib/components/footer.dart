import 'package:flutter/material.dart';

class FooterVB extends StatefulWidget {
  @override
  _FooterVBState createState() => _FooterVBState();
}

class _FooterVBState extends State<FooterVB> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/twitter.png'),height:40,width:40,),
            SizedBox(width:60),
            Image(image: AssetImage('assets/images/instagram.png'),height:40,width:40,)
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Powered by",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400),textAlign:TextAlign.center,),
              Text("VB DIGITAL UK",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.bold),textAlign:TextAlign.center,),
            ],
          ),
        ),
      ],
    );
  }
}
