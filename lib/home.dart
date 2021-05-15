import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/about_us.dart';
import 'package:inspired_catering/bar_service.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:inspired_catering/components/log_in_first.dart';
import 'package:inspired_catering/contact_us.dart';
import 'package:inspired_catering/drinks_service.dart';
import 'package:inspired_catering/food_service.dart';
import 'package:inspired_catering/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'book_event.dart';
import 'components/api.dart';
import 'components/database_helper.dart';
import 'components/todo.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cont = PageController(initialPage:0);
  int current = 0;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool loged = false;
  getUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getBool('loged')) {
      Map userdata = jsonDecode(preferences.getString('userdata'));
      name.text = "Name : ${userdata['first_name']} ${userdata['last_name']}"
          .replaceAll("[", "")
          .replaceAll("]", "");
      email.text =
          "Email : ${userdata['username']}".replaceAll("[", "").replaceAll(
              "]", "");
      phone.text = "Contact : ${userdata['user_details']['mobile']}"
          .replaceAll("[", "")
          .replaceAll("]", "");
      setState(() {
        loged = true;
      });
    }
  }
  getOrders()async{
    var dio = Dio();
    Response res;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getBool('loged')) {
      Map userdata = jsonDecode(preferences.getString('userdata'));
      res = await dio.get(Api().baseUrl + "wc/v3/orders/?customer=${userdata['user_id']}");
    }
    print(res.data);
    return res.data;
  }
  Future getOrdersF;
  logout(context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("loged", false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth()), (route) => false);
  }
  DatabaseHelper databaseHelper = DatabaseHelper();
  int noti = 0;
  Future future ;
  @override
  void initState() {
    getUserData();
    future = updateListView();
    getOrdersF = getOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView(
        controller: cont,
        onPageChanged: (v){
          setState(() {
            current = v;
          });
        },
        children: [
          ListView(
            children: [
              Container(
                height:width-100,
                child: Stack(
                  children: [
                    Image.asset('assets/images/serviceimage6.png',fit:BoxFit.cover,width:width),
                    Container(
                      color: Colors.white30,
                      height: width-100,
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Inspired Catering",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500,fontSize:32,color:Colors.white),),
                          ),
                          Divider(color: Colors.white,indent:20,endIndent: 20,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Your event our inspiration",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500,fontSize:18,color:Colors.white),),
                          ),
                          SizedBox(height:20),
                          FlatButton(
                            color: Colors.amber,
                            onPressed: (){
                              if(!loged) {
                                showCupertinoDialog(
                                    context: context, builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                        "Please Login / Sign up to continue"),
                                    actions: [
                                      FlatButton(onPressed: () =>
                                          Navigator.pop(context),
                                          child: Text("cancel")),
                                      FlatButton(onPressed: () =>
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Auth()), (
                                                  route) => false),
                                          child: Text("login")),
                                    ],
                                  );
                                });
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BookEvent()));
                              }
                            }, child:Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("BOOK US FOR EVENT",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400),),
                            ),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20,bottom:10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs())),
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            width:width*0.5-20,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("ABOUT US",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Services() )),
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            width:width*0.5-20,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("SERVICES",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20,bottom:10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodServices())),
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            width:width*0.5-20,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("FOOD CATERING",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DrinksService())),
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            width:width*0.5-20,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("DRINKS CATERING",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20,bottom:10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>BarServices())),
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            width:width*0.5-20,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("BAR PACKAGES",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUs())),
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            width:width*0.5-20,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("CONTACT US",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FooterVB()
            ],
          ),
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading:SizedBox(),
              leadingWidth: 0,
              title: Text("My Orders",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
            ),
            body:loged?FutureBuilder(
              future: getOrdersF,
              builder: (context, snapshot) {
                if(snapshot.connectionState!=ConnectionState.waiting) {
                  if(snapshot.hasData) {
                    print(snapshot.data);
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Order Date : ${snapshot.data[index]['date_created']}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  )),
                                  Text("Order Status : ${snapshot.data[index]['status']}",style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Order Total : £${snapshot.data[index]['total']}"),
                                  Text("Order Type : ${snapshot.data[index]['date_created']}"),
                                  Text("Payment Type : ${snapshot.data[index]['payment_method']}"),
                                  SizedBox(height:10),
                                  Text("Order Items",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text("----------------",style: TextStyle(fontWeight: FontWeight.bold),),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:snapshot.data[index]['line_items'].length,
                                    itemBuilder: (context,indx){
                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text("${snapshot.data[index]['line_items'][indx]['name']} ${snapshot.data[index]['line_items'][indx]['quantity']} x £${snapshot.data[index]['line_items'][indx]['price']}"),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  }else{
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/noorders.jpeg',width:250,),
                          SizedBox(height:20),
                          Text("No Orders Found",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.bold,fontSize:28,color:Colors.pink)),
                        ],
                      ),
                    );
                  }
                }else{
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }
            ):Center(child:LogInFirst()),
            bottomNavigationBar: FooterVB(),
          ),
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading:SizedBox(),
              leadingWidth: 0,
              title: Text("Profile",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
            ),
            body: loged?Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TextFormField(
                    controller: name,
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "",
                      prefixIcon: Icon(CupertinoIcons.profile_circled)
                    ),
                    validator: (v){
                      if(v.isEmpty){
                        return "Please Enter Your First Name";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "",
                        prefixIcon: Icon(CupertinoIcons.mail)
                    ),
                    validator: (v){
                      if(v.isEmpty){
                        return "Please Enter Your Last Name";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phone,
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "",
                        prefixIcon: Icon(CupertinoIcons.phone)
                    ),
                    validator: (v){
                      if(v.isEmpty){
                        return "Please Enter Your Email";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: Card(
                      color: Colors.pink,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: FlatButton.icon(
                          color: Colors.pink,
                          textColor: Colors.white,
                          onPressed: ()=>logout(context),label: Text("Logout"),icon: Icon(Icons.logout,color: Colors.white,),),
                      ),
                    ),
                  ),
                ],
              ),
            ):Center(child:LogInFirst()),
            bottomNavigationBar:FooterVB(),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading:SizedBox(),
              leadingWidth: 0,
              title: Text("Notifications",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
            ),
           /* floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('FAB clicked');
                databaseHelper.insertTodo(Todo("hhhh",DateTime.now().toString(),"hjhhhjhjh"));
                setState(() {
                  future = updateListView();
                });
              },
              tooltip: 'Add Todo',
              child: Icon(Icons.add),
            ),*/
            body: Container(
              child: FutureBuilder<List<Todo>>(
                future: future,
                builder: (context, snapshot) {
                  if(snapshot.connectionState!=ConnectionState.waiting) {
                    if(snapshot.data!=null) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int position) {
                          return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              title: Text("${snapshot.data[position].title}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "${snapshot.data[position].description}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Icon(
                                      Icons.delete, color: Colors.red,),
                                    onTap: () {
                                      _delete(context, snapshot.data[position]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/noorders.jpeg',width:250,),
                            SizedBox(height:20),
                            Text("No Notifications",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.bold,fontSize:22,color:Colors.pink)),
                          ],
                        ),
                      );
                    }
                  }else{
                    return Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: Border(),
        currentIndex: current,
        onTap: (page){
          setState(() {
            current = page;
          });
          cont.animateToPage(page, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),title:Text("Home")),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart),title:Text("My Orders")),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_2_fill),title:Text("Profile")),
          BottomNavigationBarItem(icon: Badge(
            padding: EdgeInsets.all(2),
              toAnimate: false,
              badgeContent: Text("$noti",style: TextStyle(color: Colors.white),),
              child: Icon(CupertinoIcons.bell)),title:Text("Notifications")),
        ],
      ),
    );
  }
  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Notification Deleted Successfully');
      setState(() {
        future = updateListView();
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
  Future<List<Todo>> updateListView()async{
    final dbFuture = await databaseHelper.initializeDatabase();
    setState(() async {
      noti = await databaseHelper.getCount();
    });
    return databaseHelper.getTodoList();
  }
}
