import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/api.dart';
import 'package:inspired_catering/components/custom_loder.dart';
import 'package:inspired_catering/forgot_password.dart';
import 'package:inspired_catering/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/footer.dart';
import 'dart:io' show Platform;

class LoginScrren extends StatefulWidget {
  @override
  _LoginScrrenState createState() => _LoginScrrenState();
}

class _LoginScrrenState extends State<LoginScrren> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool show = true,loging=false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Log In",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:0.0,horizontal:20.0),
        child: Form(
          key: formKey,
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
              TextFormField(
                controller: password,
                obscureText: show,
                decoration: InputDecoration(
                    hintText: "Enter Password",
                  suffixIcon: IconButton(icon:Icon(show?CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill),onPressed: ()=>setState(()=>show=!show))
                ),
                validator: (v){
                  if(v.isEmpty){
                    return "Please Enter Your Password";
                  }else{
                    return null;
                  }
                },
              ),
              !loging?GestureDetector(
                onTap: ()async{
                  var dio = Dio();
                  var token = await FirebaseMessaging.instance.getToken();
                  print(token);
                  var apnToken = FirebaseMessaging.instance.getAPNSToken();
                  var device = "Android";
                  if(Platform.isAndroid){
                    device = "Android";
                  }else{
                    device = "Ios";
                  }
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(formKey.currentState.validate()){
                    setState(() {
                      loging = true;
                    });
                    var formData = FormData.fromMap({
                      "username":email.text,
                      "password":password.text,
                      "dev_key":token,
                      "device_type":device
                    });
                    Response res = await  dio.post(Api().baseUrl+"vb-digital/login",
                      data: formData
                    );
                    if(res.statusCode==200){
                      print(res.data);
                      if(res.data['status'].toString()=="true"){
                        prefs.setString('userdata',"${jsonEncode(res.data)}");
                        prefs.setBool("loged", true);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(route) => false);
                      }else{
                        setState(() {
                          loging = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Username and Password Not Matched !")));
                      }
                    }else{
                      setState(() {
                        loging = false;
                      });
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Server Unavailable ! try again")));
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:0,vertical:8),
                  child: Card(
                    color: Colors.amber,
                    child: Container(
                      width:MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.center,
                      child: Text("SIGN IN",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                    ),
                  ),
                ),
              ):Padding(
                padding: EdgeInsets.symmetric(horizontal:0,vertical:8),
                child: Card(
                  color: Colors.amber,
                  child: Container(
                    width:MediaQuery.of(context).size.width,
                    height: 40,
                    alignment: Alignment.center,
                    child: ColorLoader(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Forgot Password ?",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500,color: Colors.blue,decoration:TextDecoration.underline,fontSize: 16),textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height:90,
        child: FooterVB(),
      ),
    );
  }
}
