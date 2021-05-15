import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/place_order.dart';

import 'components/api.dart';
import 'components/custom_dropdown.dart';

class DrinksService extends StatefulWidget {
  const DrinksService({Key key}) : super(key: key);

  @override
  _DrinksServiceState createState() => _DrinksServiceState();
}

class _DrinksServiceState extends State<DrinksService> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> m = [];
  Map selected = {"name":"","id":108,"description":""};
  getItems()async{
    var dio = Dio();
    var req = await dio.get(Api().baseUrl +"wc/v3/products/categories?parent=78");
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
    var req = await dio.get(Api().baseUrl +"wc/v3/products?category=$id");
    return req.data;
  }
  List cartProductList = [];
  List cartNameList = [];
  List cartQuantatyList = [];
  List cartPriceList =[];
  @override
  void initState() {
    getItems();
    super.initState();
  }
  int sum = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          showDialog(context: context, builder: (context){
            return Center(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: Text("CART CONTENTS",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                        trailing: IconButton(icon: Icon(Icons.close_rounded),onPressed: ()=>Navigator.pop(context),),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal:30,vertical:10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartProductList.length,
                            itemBuilder: (context,index){
                              if(cartQuantatyList[index]!=0) {
                                return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${cartNameList[index]}"),
                                          Text("£ ${int.parse(cartPriceList[index])*cartQuantatyList[index]}",style: TextStyle(fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                );
                              }else{
                                return SizedBox();
                              }
                            }),

                      ),
                      GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceOrder(priceList:cartPriceList,nameList:cartNameList,qntyList:cartQuantatyList,idList:cartProductList,))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal:30,vertical:10),
                          child: Card(
                            color: Colors.amber,
                            child: Container(
                              width:MediaQuery.of(context).size.width,
                              height: 40,
                              alignment: Alignment.center,
                              child: Text("CHECKOUT"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
        backgroundColor: Colors.blue,
        label: Badge(
          badgeColor: Colors.blue,
          elevation: 0,
          padding: EdgeInsets.all(1),
            badgeContent: Text('$sum',style: TextStyle(color: Colors.white,fontSize:12),),
            child: Icon(Icons.shopping_cart,color: Colors.white)
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Drinks Catering",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
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
            title: Text("${selected["name"]}",
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,),
            subtitle: Text(
              "${selected["description"]}",
              style: TextStyle(fontWeight: FontWeight.normal,
                  color: Colors.black),textAlign: TextAlign.center,),
          ),
          FutureBuilder(
              future: getList(selected['id']),
              builder: (context, snapshot) {
                if(snapshot.connectionState!=ConnectionState.waiting) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data[index]);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black,width:1)
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("${snapshot.data[index]["name"]}",
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data[index]["slug"]}",
                                      style: TextStyle(fontWeight: FontWeight.normal,
                                          color: Colors.black),),
                                    Text(
                                      "${snapshot.data[index]["description"]}",
                                      style: TextStyle(fontWeight: FontWeight.normal,
                                          color: Colors.black),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("£${snapshot.data[index]["regular_price"]}",style: TextStyle(fontSize:22,fontWeight: FontWeight.bold,color: Colors.red,decoration:TextDecoration.lineThrough),),
                                                Text("£${snapshot.data[index]["price"]}",style: TextStyle(fontSize:22,fontWeight: FontWeight.bold,color: Colors.green,decoration:TextDecoration.none),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(icon: Icon(Icons.add_circle_rounded,color:Colors.blue,),onPressed: (){
                                                 if(cartProductList.contains(snapshot.data[index]["id"])){
                                                   cartQuantatyList[cartProductList.indexOf(snapshot.data[index]["id"])] = cartQuantatyList[cartProductList.indexOf(snapshot.data[index]["id"])]+1;
                                                 }else{
                                                   cartQuantatyList.add(1);
                                                   cartProductList.add(snapshot.data[index]["id"]);
                                                   cartNameList.add(snapshot.data[index]["name"]);
                                                   cartPriceList.add(snapshot.data[index]["price"]);
                                                 }
                                                 int summ =  0;
                                                 cartQuantatyList.forEach((element) {
                                                   summ = summ+element;
                                                 });
                                                 setState(() {
                                                   sum = summ;
                                                 });
                                                 print(cartProductList);
                                                 print(cartQuantatyList);
                                                 print(cartNameList);
                                                }),
                                                Text("${cartProductList.contains(snapshot.data[index]["id"])?cartQuantatyList[cartProductList.indexOf(snapshot.data[index]["id"])]:0}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                                                IconButton(icon: Icon(Icons.remove_circle,color:Colors.blue,),onPressed: (){
                                                  if(cartProductList.contains(snapshot.data[index]["id"])){
                                                    if(cartQuantatyList[cartProductList.indexOf(snapshot.data[index]["id"])]>0){
                                                      cartQuantatyList[cartProductList.indexOf(snapshot.data[index]["id"])] = cartQuantatyList[cartProductList.indexOf(snapshot.data[index]["id"])]-1;
                                                  }}
                                                  int summ =  0;
                                                  cartQuantatyList.forEach((element) {
                                                    summ = summ+element;
                                                  });
                                                  setState(() {
                                                    sum = summ;
                                                  });
                                                  print(cartProductList);
                                                  print(cartQuantatyList);
                                                  print(cartNameList);
                                                },),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                      );
                    },
                  );
                }else{
                  return Container(
                    height:500,
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              }
          )
        ],
      ),
    );
  }
}
