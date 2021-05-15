import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api.dart';
import 'components/custom_loder.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  bool loging=false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Contact Us",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset("assets/images/contact1.png"),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 5),
              child: Text("Ready to book us for your next event? If you have any questions about our services or need to let us know your requirements or ideas, please get in touch and we'll get back to you as soon as possible."),
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
                    //Navigator.pop(context);
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
                    horizontal: 20, vertical: 8),
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
                  horizontal: 20, vertical: 8),
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
      ),
    );
  }
}
