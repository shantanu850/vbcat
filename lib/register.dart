import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/api.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:inspired_catering/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/custom_loder.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loging=false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Register",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
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
                controller: fname,
                decoration: InputDecoration(
                  hintText: "First Name*"
                ),
                validator: (v){
                  if(v.isEmpty){
                    return "Please Enter Your First Name";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: lname,
                decoration: InputDecoration(
                    hintText: "Last Name*"
                ),
                validator: (v){
                  if(v.isEmpty){
                    return "Please Enter Your Last Name";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10),
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
                controller: phone,
                decoration: InputDecoration(
                    hintText: "Phone Number*"
                ),
                validator: (v){
                  if(v.isEmpty){
                    return "Please Enter Your Phone Number";
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
              !loging?GestureDetector(
                onTap: ()async{
                  var dio = Dio();
                  var token = FirebaseMessaging.instance.getToken();
                  var device = "Android";
                  if(Platform.isAndroid){
                    device = "Android";
                  }else{
                    device = "Ios";
                  }
                  //first_name, last_name, password,
                  // email, mobile, device_type, dev_key
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(formKey.currentState.validate()){
                    setState(() {
                      loging = true;
                    });
                    var formData = FormData.fromMap({
                      "first_name":fname.text,
                      "last_name":lname.text,
                      "email":email.text,
                      "mobile":phone.text,
                      "password":password.text,
                      "dev_key":token,
                      "device_type":device
                    });
                    var autoLogin = FormData.fromMap({
                      "username":email.text,
                      "password":password.text,
                      "dev_key":token,
                      "device_type":device
                    });
                    Response res = await  dio.post(Api().baseUrl+"wp/v2/users/register",
                        data: formData
                    );
                    if(res.statusCode==200){
                      print(res.data);
                      if(res.data['code'].toString()=="200"){
                        Response rese = await  dio.post(Api().baseUrl+"vb-digital/login",
                            data: autoLogin
                        );
                        prefs.setString('userdata',"${jsonEncode(rese.data)}");
                        prefs.setBool("loged", true);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(route) => false);
                      }else{
                        setState(() {
                          loging = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Something went wrong ! try again")));
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
                      child: Text("SIGN UP",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
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
