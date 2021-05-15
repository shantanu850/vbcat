import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api.dart';
import 'components/custom_dropdown.dart';
import 'components/custom_loder.dart';
import 'components/flutter_datetime_picker.dart';

class BookEvent extends StatefulWidget {
  const BookEvent({Key key}) : super(key: key);

  @override
  _BookEventState createState() => _BookEventState();
}

class _BookEventState extends State<BookEvent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> m = [];
  Map selected = {"name":"","id":56,"description":""};
  getItems()async{
    var dio = Dio();
    var req = await dio.get(Api().baseUrl +"wc/v3/products/categories?parent=40");
    List nn = req.data;
    nn.forEach((element) {
      m.add(element);
    });
    setState(() {
      selected = nn.first;
    });
  }
  getList(id)async{
    var dio = Dio();
    var req = await dio.get(Api().baseUrl +"wc/v3/products/categories?parent=$id");
    return req.data;
  }
  @override
  void initState() {
    getItems();
    super.initState();
  }
  bool loging=false;
  TextEditingController datec = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Book for an Event",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.bold,color:Colors.green)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2050, 6, 7), onChanged: (date) {
                        setState(() {
                          datec.text = "${date.day}/${date.month}/${date.year}";
                        });
                      }, onConfirm: (date) {
                        setState(() {
                          datec.text = "${date.day}/${date.month}/${date.year}";
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: TextFormField(
                  controller: datec,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "Select Date"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Select Date";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      showSecondsColumn: false,
                      onChanged: (date) {
                        setState(() {
                          time.text = "${date.hour}:${date.minute}";
                        });
                      }, onConfirm: (date) {
                        setState(() {
                          time.text = "${date.hour}:${date.minute}";
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: TextFormField(
                  controller: time,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "Select Time"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Select Time";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    hintText: "Enter Event Name"
                ),
                validator: (v){
                  if(v.isEmpty){
                    return "Please Enter Event Name";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: m.length,
                            itemBuilder: (context,index){
                              return ListTile(title:Text(m[index]['name']),
                                onTap: (){
                                  setState(() {
                                    selected = m[index];
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        });
                  },
                  child: CustomDropdown(title:"Select",selected:"${selected['name']}",)),
              ListTile(
                title: Text("Selected - ${selected['name']}",textAlign: TextAlign.center,),
              ),
              !loging?GestureDetector(
                onTap: ()async{
                  var dio = Dio();
                  //event_date, event_time, event_title, bar_package_name, user_email,
                  //         user_name, user_id, bar_package_id
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Map userdata = jsonDecode(
                      prefs.getString('userdata'));
                  if(formKey.currentState.validate()){
                    setState(() {
                      loging = true;
                    });
                    var formData = FormData.fromMap({
                      "event_date":datec.text,
                      "event_time":time.text,
                      "event_title":email.text,
                      "bar_package_name":selected['name'],
                      "bar_package_id":selected['id'],
                      "user_email":"${userdata['username']}",
                      "user_name":"${userdata['first_name']} ${userdata['last_name']}",
                      "user_id":"${userdata['user_id']}",
                    });
                    Response res = await  dio.post(Api().baseUrl+"wp/v2/book-event/add-new",
                        data: formData
                    );
                    if(res.statusCode==200){
                      print(res.data);
                      if(res.data['code'].toString()=="200"){
                        setState(() {
                          loging = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${res.data['message']}")));
                      }else{
                        setState(() {
                          loging = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Server Unavailable ! try again")));
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
                      child: Text("Book Now",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
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
      bottomNavigationBar: FooterVB(),
    );
  }
}
