import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api.dart';
import 'components/custom_loder.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
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
        title: Text("About Us",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
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
        onPressed: (){
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
                        trailing: IconButton(icon: Icon(Icons.close_rounded), onPressed:()=>Navigator.pop(context)),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
                        child: Text("Hi! Let us know how we can help and we'll response shortly"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
                        child: Text("Enter Subject"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical:5),
                        child: TextFormField(
                          controller: subject,
                          decoration: InputDecoration(
                              hintText: "",
                              border: OutlineInputBorder()
                          ),
                          validator: (v){
                            if(v.isEmpty){
                              return "Please Enter Subject";
                            }else{
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
                        child: Text("Enter Your Message"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
                        child: TextFormField(
                          controller: message,
                          maxLines: 10,
                          minLines: 5,
                          decoration: InputDecoration(
                              hintText: "",
                              border: OutlineInputBorder()
                          ),
                          validator: (v){
                            if(v.isEmpty){
                              return "Please Enter Your Message";
                            }else{
                              return null;
                            }
                          },
                        ),
                      ),
                      !loging?GestureDetector(
                        onTap: ()async{
                          //yourName, yourEmail, yourSubject,
                          // yourMessage
                          var dio = Dio();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          Map userdata = jsonDecode(prefs.getString('userdata'));
                          if(formKey.currentState.validate()){
                            setState(() {
                              loging = true;
                            });
                            var formData = FormData.fromMap({
                              "yourSubject":subject.text,
                              "yourMessage":message.text,
                              "yourName":"${userdata['first_name']} ${userdata['last_name']}".replaceAll("[","").replaceAll("]",""),
                              "yourEmail":"${userdata['username']}".replaceAll("[","").replaceAll("]","")
                            });
                            Response res = await  dio.post(Api().baseUrl+"wp/v2/contact-us/add-new",
                                data: formData
                            );
                            if(res.statusCode==200){
                              print(res.data);
                                setState(() {
                                  loging = false;
                                });
                                scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Your Message was send !")));
                                Navigator.pop(context);
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
                              child: Text("Send Message",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
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
                );
              });

        },
        backgroundColor: Colors.amber,
        child:Icon(CupertinoIcons.chat_bubble_2_fill,color: Colors.black,),
      ),
      bottomNavigationBar: Container(height:90,child: FooterVB()),
    );
  }
}
