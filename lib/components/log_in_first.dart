import 'package:flutter/material.dart';
import 'package:inspired_catering/main.dart';
class LogInFirst extends StatelessWidget {
  const LogInFirst({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("To continue please sign in",textAlign: TextAlign.center,style: TextStyle(fontSize:22),),
              SizedBox(height:20),
              Center(
                child: Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: FlatButton.icon(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth()), (route) => false),label: Text("Sign In"),icon: Icon(Icons.login,color: Colors.white,),),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
