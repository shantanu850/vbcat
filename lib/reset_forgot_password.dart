import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/main.dart';

import 'components/api.dart';
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
  bool show = true,show2=true,loging=false;
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
        title: Text("Reset Password",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
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
                obscureText: show,
                decoration: InputDecoration(
                    hintText: "Password*",
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
              SizedBox(height: 10),
              TextFormField(
                controller: conf_pass,
                obscureText: show2,
                decoration: InputDecoration(
                    hintText: "Retype Password*",
                    suffixIcon: IconButton(icon:Icon(show2?CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill),onPressed: ()=>setState(()=>show2=!show2))
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
                onTap: ()async{
                  var dio = Dio();
                  if(formKey.currentState.validate()){
                    setState(() {
                      loging = true;
                    });
                    var formData = FormData.fromMap({
                      "username":email.text,
                      "password":password.text,
                      "code":code.text
                    });
                    Response res = await  dio.post(Api().baseUrl+"bdpwr/v1/set-password",
                        data: formData
                    );
                    if(res.statusCode==200){
                      print(res.data);
                      if(res.data['data']['status'].toString()=="200"){
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Password Reset Successfully !")));
                        await Future.delayed(Duration(seconds:1));
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth()),(route) => false);
                      }else{
                        setState(() {
                          loging = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Code Not Matched !")));
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
                      child: Text("RESET PASSWORD",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                    ),
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
