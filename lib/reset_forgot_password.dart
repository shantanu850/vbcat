import 'package:flutter/material.dart';

import 'components/footer.dart';

class ResetForgotPassword extends StatefulWidget {
  @override
  _ResetForgotPasswordState createState() => _ResetForgotPasswordState();
}

class _ResetForgotPasswordState extends State<ResetForgotPassword> {
  TextEditingController code = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController conf_pass = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Reset Password",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
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
                  hintText: "Email*"
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
            TextFormField(
              controller: code,
              decoration: InputDecoration(
                  hintText: "Four Digit Code*"
              ),
              validator: (v){
                if(v.isEmpty){
                  return "Please Enter Code";
                }else{
                  return null;
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                  hintText: "Password*"
              ),
              validator: (v){
                if(v.isEmpty){
                  return "Please Enter Your Password";
                }else{
                  return null;
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: conf_pass,
              decoration: InputDecoration(
                  hintText: "Retype Password*"
              ),
              validator: (v){
                if(v.isEmpty){
                  return "Please Enter Your Password";
                }else{
                  return null;
                }
              },
            ),
            GestureDetector(
              //onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:0,vertical:8),
                child: Card(
                  color: Colors.amber,
                  child: Container(
                    width:MediaQuery.of(context).size.width,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("RESET PASSWORD",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                  ),
                ),
              ),
            ),
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
