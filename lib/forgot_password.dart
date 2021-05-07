import 'package:flutter/material.dart';
import 'package:inspired_catering/reset_forgot_password.dart';

import 'components/footer.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Forgot Password",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:0.0,horizontal:20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20),
              child: Image(image: AssetImage('assets/images/favicon.png'),height:80,),
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  hintText: "Enter Email"
              ),
              validator: (v){
                if(v.isEmpty){
                  return "Please Enter Your Email";
                }else{
                  return null;
                }
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:0,vertical:8),
                child: Card(
                  color: Colors.amber,
                  child: Container(
                    width:MediaQuery.of(context).size.width,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("SEND",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0),
              child: RichText(
                  text: TextSpan(
                      text:"Please provide the email address that you used when you sign up for",
                      style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500,color: Colors.black),
                    children: [
                      TextSpan(
                          text:" Inspired Catering",
                          style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.bold,color: Colors.black),
                      ),
                    ]
                  ),
              ),
            ),
            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetForgotPassword())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Already have a code ? click to reset your password",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600,color: Colors.amber,fontSize: 16),textAlign: TextAlign.center),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height:90,
        child: FooterVB(),
      ),
    );
  }
}
