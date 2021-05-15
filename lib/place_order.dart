import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:inspired_catering/components/custom_loder.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:inspired_catering/home.dart';
import 'package:inspired_catering/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api.dart';

class PlaceOrder extends StatefulWidget {
  @required final List priceList;
  @required final List nameList;
  @required final List qntyList;
  @required final List idList;
  const PlaceOrder({Key key, this.priceList, this.nameList, this.qntyList, this.idList}) : super(key: key);

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  bool paying=false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
    List priceList =[];
    List nameList=[];
    List qntyList=[];
    List idList=[];
    initState(){
      super.initState();
      initilizeList();

    }
    int total = 0;
  initilizeList(){
      print(widget.qntyList);
      print(widget.nameList);
      print(widget.idList);
      print(widget.priceList);
      for(int i=0;i<=widget.qntyList.length-1;i++) {
          if (widget.qntyList[i] != 0) {
            qntyList.add(widget.qntyList[i]);
            nameList.add(widget.nameList[i]);
            idList.add(widget.idList[i]);
            priceList.add(widget.priceList[i]);
          }
      }
      for(int j=0;j<=priceList.length-1;j++){
        print(qntyList[j]);
        print(priceList[j]);
        total = total+int.parse(priceList[j])*qntyList[j];
      }
      print(qntyList);
      print(nameList);
      print(idList);
      print(priceList);
  }
  bool orderType = true,paymentType=true;
  TextEditingController fline = TextEditingController();
  TextEditingController sline = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController country = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Place Order",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.bold,color:Colors.green)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(height:25),
            Container(
              padding: EdgeInsets.symmetric(horizontal:30,vertical:10),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: idList.length,
                  itemBuilder: (context,index){
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${nameList[index]}",style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("£ ${int.parse(priceList[index])*qntyList[index]}",style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                  }),

            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:30,vertical:0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount",style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("£ $total",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height:15),
            ListTile(
              title: Text("Please Select Order Type",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
            ),
            ListTile(
              title: Text("Home Delivery"),
              subtitle: Text("(Excluding delivery fee)"),
              leading: SizedBox(
                height: 50,
                width: 56,
                child: RadioButton(
                    value:true,
                    groupValue: orderType,
                    onChanged: (v){
                      setState(() {
                        orderType = v;
                        paymentType = false;
                      });
                    },
                    description: '',),
              ),
            ),
            ListTile(
              title: Text("Collection"),
              subtitle: Text("(Details circulated upon selection)"),
              leading: SizedBox(
                height: 50,
                width: 56,
                child: RadioButton(
                  value:false,
                  groupValue: orderType,
                  onChanged: (v){
                    setState(() {
                      orderType = v;
                    });
                  },
                  description: '',),
              ),
            ),
            orderType?ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              physics: NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  title: Text("Enter Delivery Address",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                ),
                TextFormField(
                  controller: fline,
                  decoration: InputDecoration(
                      hintText: "First line of address"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Enter Your Address";
                    }else{
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: sline,
                  decoration: InputDecoration(
                      hintText: "Second line of address"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Enter Your address";
                    }else{
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: city,
                  decoration: InputDecoration(
                      hintText: "Enter City"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Enter City";
                    }else{
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: pin,
                  decoration: InputDecoration(
                      hintText: "Pincode"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Enter Pincode";
                    }else{
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: country,
                  decoration: InputDecoration(
                      hintText: "Enter Country"
                  ),
                  validator: (v){
                    if(v.isEmpty){
                      return "Please Enter Your Country Name";
                    }else{
                      return null;
                    }
                  },
                ),
              ],
            ):SizedBox(),
            ListTile(
              title: Text("Select Payment Type",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
            ),
            !orderType?ListTile(
              title: Text("Cash On Delivery"),
              subtitle: Text(""),
              leading: SizedBox(
                height: 50,
                width: 56,
                child: RadioButton(
                  value:true,
                  groupValue: paymentType,
                  onChanged: (v){
                    setState(() {
                      paymentType = v;
                    });
                  },
                  description: '',),
              ),
            ):SizedBox(),
            ListTile(
              title: Text("Bank Transfer"),
              subtitle: Text("(Details circulated upon selection)"),
              leading: SizedBox(
                height: 50,
                width: 56,
                child: !orderType?RadioButton(
                  value:false,
                  groupValue: paymentType,
                  onChanged: (v){
                    setState(() {
                      paymentType = v;
                    });
                  },
                  description: '',):Icon(Icons.check_circle_outline),
              ),
            ),
            SizedBox(height:20),
            Center(
              child: Card(
                color: Colors.amber,
                child: Container(
                  width: 130+63.0,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: !paying?FlatButton.icon(
                      onPressed: ()async{
                        //payment_method, payment_method_title, set_paid, currency (GBP),
                        //         customer_id, customer_note, transaction_id (NA), billing,
                        //         shipping,
                        //shipping = {'first_name' : this.fname, 'last_name': this.lname, 'address_1': this.inputAddress,
                        //     'address_2' : this.inputAddress2, 'city' : this.inputCity, 'state' : this.inputState, 'postcode' : this.inputPin,
                        //     'country' : this.inputCountry,  'email' : this.email, 'phone' : this.mobile}
                        //billing = {'first_name' : this.fname, 'last_name': this.lname, 'address_1': 'Not Available',
                        //     'address_2' : 'Not Available', 'city' : 'Not Available', 'state' : 'Not Available', 'postcode' : 'Not Available',
                        //     'country' : 'Not Available', 'email' : this.email, 'phone' : this.mobile}

                        //line_items will be json array contains
                        // json object of two items
                        // 1. product_id. 2. quantity
                        //if(selectedRadioItemPayment === "cash"){
                        //          payment_method = "Cash On Delivery"
                        //          payment_method_title = "Cash On Delivery"
                        //         }else{
                        //          payment_method = "Bank Transfer"
                        //          payment_method_title = "Bank Transfer"
                        //         }
                        var dio = Dio();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        Map userdata = jsonDecode(prefs.getString('userdata'));
                        List<Map> lineItems = [];
                        for(var i=0;i<=idList.length-1;i++){
                          lineItems.add({
                            "product_id":idList[i],
                            "quantity":qntyList[i]
                          });
                        }
                        print(lineItems);
                          if(orderType?formKey.currentState.validate():true) {
                            setState(() {
                              paying = true;
                            });
                            var data = FormData.fromMap({
                              "payment_method":!paymentType?"Bank Transfer":"Cash On Delivery",
                              "payment_method_title":!paymentType?"Bank Transfer":"Cash On Delivery",
                              "set_paid":orderType,
                              "currency":"GBP",
                              "customer_id":"${userdata['user_id']}",
                              "customer_note":"NA",
                              "transaction_id":"NA",
                              "billing":{
                                'first_name' : "${userdata['first_name']}",
                                'last_name': "${userdata['last_name']}",
                                'address_1': 'Not Available',
                                'address_2' : 'Not Available',
                                'city' : 'Not Available',
                                'state' : 'Not Available',
                                'postcode' : 'Not Available',
                                'country' : 'Not Available',
                                'email' : "${userdata['username']}",
                                'phone' : "${userdata['user_details']['mobile']}"
                              },
                              "shipping":{
                                'first_name' : "${userdata['first_name']}",
                                'last_name': "${userdata['last_name']}",
                                'address_1': fline.text,
                                'address_2' : sline.text,
                                'city' : city.text,
                                'state' : 'Not Available',
                                'postcode' : pin.text,
                                'country' : country.text,
                                'email' : "${userdata['username']}",
                                'phone' : "${userdata['user_details']['mobile']}"
                              },
                              "line_items":lineItems
                            });
                            Response res = await  dio.post(Api().baseUrl+"wc/v3/orders",
                                data: data
                            );
                            print(res.data);
                            if(res.data!=null){
                              showDialog(
                                  barrierDismissible: false,
                                  context: context, builder: (context){
                                return WillPopScope(
                                  onWillPop: ()async=>false,
                                  child: AlertDialog(
                                    title: Text("Order Placed Successfully !",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                                    content: Text("Order Id ${res.data['id']}"),
                                    actions: [
                                      FlatButton(onPressed: ()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false),
                                          child: Text("Done"))
                                    ],
                                  ),
                                );
                              });
                            }
                          }
                        },
                      textColor: Colors.black,
                      color: Colors.amber,
                      icon: Icon(Icons.check_circle_outline,color: Colors.black),
                      label: Text("Place Order",style: TextStyle(fontSize: 18),)
                  ):ColorLoader(),
                ),
              ),
            ),
            SizedBox(height:40),
            FooterVB()
          ],
        ),
      ),
    );
  }
}
