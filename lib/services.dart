import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:inspired_catering/contact_us.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api.dart';
import 'components/custom_loder.dart';
import 'main.dart';

class Services extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<Services> {
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  bool loging=false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
            child: Image.asset('assets/images/serviceimage1.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("No matter what you have in mind, we can help! Each of our events is fully managed by experienced catering staff, providing fresh, delicious and nutritious food and drink to an affordable budget.",
              textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontFamily: 'proxima'),),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/images/serviceimage2.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Our top of range mobile bars are easily accessible and affordable. Fully equipped to suits your events needs.",
              textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontFamily: 'proxima'),),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('assets/images/serviceimage3.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Weddings",
              textAlign: TextAlign.center,style: TextStyle(fontSize:  18,fontWeight:FontWeight.bold,fontFamily: 'proxima'),),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('assets/images/serviceimage4.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Corporate Events",
              textAlign: TextAlign.center,style: TextStyle(fontSize:  18,fontWeight:FontWeight.bold,fontFamily: 'proxima'),),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset('assets/images/serviceimage5.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Private Parties",
              textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold,fontFamily: 'proxima'),),
          ),
          Container(
            height:width-150,
            child: Stack(
              children: [
                Image.asset('assets/images/serviceimage6.png',fit:BoxFit.cover,width:width),
                Container(
                  color: Colors.white30,
                  height: width-150,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Have an idea for an event?",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500,fontSize:32,color:Colors.white),textAlign: TextAlign.center,),
                      ),
                      SizedBox(height:20),
                      FlatButton(
                        color: Colors.amber,
                        onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUs()));
                        }, child:Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("GET IN TOUCH",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400),),
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if(prefs.getBool('loged')) {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          tileColor: Colors.amber,
                          title: new Text('Inspired Catering'),
                          trailing: IconButton(icon: Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(context)),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Text(
                              "Hi! Let us know how we can help and we'll response shortly"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Text("Enter Subject"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: TextFormField(
                            controller: subject,
                            decoration: InputDecoration(
                                hintText: "",
                                border: OutlineInputBorder()
                            ),
                            validator: (v) {
                              if (v.isEmpty) {
                                return "Please Enter Subject";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Text("Enter Your Message"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: TextFormField(
                            controller: message,
                            maxLines: 10,
                            minLines: 5,
                            decoration: InputDecoration(
                                hintText: "",
                                border: OutlineInputBorder()
                            ),
                            validator: (v) {
                              if (v.isEmpty) {
                                return "Please Enter Your Message";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        !loging ? GestureDetector(
                          onTap: () async {
                            //yourName, yourEmail, yourSubject,
                            // yourMessage
                            var dio = Dio();
                            SharedPreferences prefs = await SharedPreferences
                                .getInstance();
                            Map userdata = jsonDecode(
                                prefs.getString('userdata'));
                            if (formKey.currentState.validate()) {
                              setState(() {
                                loging = true;
                              });
                              var formData = FormData.fromMap({
                                "yourSubject": subject.text,
                                "yourMessage": message.text,
                                "yourName": "${userdata['first_name']} ${userdata['last_name']}"
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""),
                                "yourEmail": "${userdata['username']}"
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                              });
                              Response res = await dio.post(
                                  Api().baseUrl + "wp/v2/contact-us/add-new",
                                  data: formData
                              );
                              if (res.statusCode == 200) {
                                print(res.data);
                                setState(() {
                                  loging = false;
                                });
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("Your Message was send !")));
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  loging = false;
                                });
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        "Server Unavailable ! try again")));
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
                            child: Card(
                              color: Colors.amber,
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text("Send Message", style: TextStyle(
                                    fontFamily: "proxima",
                                    fontWeight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ) : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8),
                          child: Card(
                            color: Colors.amber,
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 40,
                              alignment: Alignment.center,
                              child: ColorLoader(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }else{
            showCupertinoDialog(context: context, builder:(context){
              return CupertinoAlertDialog(
                title: Text("Please Login / Sign up to continue"),
                actions: [
                  FlatButton(onPressed: ()=>Navigator.pop(context), child: Text("cancel")),
                  FlatButton(onPressed: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth()), (route) => false), child: Text("login")),
                ],
              );
            });
          }
        },
        backgroundColor: Colors.amber,
        child:Icon(CupertinoIcons.chat_bubble_2_fill,color: Colors.black,),
      ),
      bottomNavigationBar: Container(height:90,child: FooterVB()),
    );
  }
}
