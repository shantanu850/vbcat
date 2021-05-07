import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/about_us.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:inspired_catering/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  getUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map userdata = jsonDecode(preferences.getString('userdata'));
    name.text = "Name : ${userdata['first_name']} ${userdata['last_name']}".replaceAll("[","").replaceAll("]","");
    email.text = "Email : ${userdata['username']}".replaceAll("[","").replaceAll("]","");
    phone.text = "Contact : ${userdata['user_details']['mobile']}".replaceAll("[","").replaceAll("]","");
  }
  logout(context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("loged", false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth()), (route) => false);
  }
  @override
  void initState() {
    getUserData();
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
                            onPressed: (){}, child:Padding(
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
                      // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
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
                      //   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
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
                      // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
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
                      //   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
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
            body:FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                if(snapshot.connectionState!=ConnectionState.waiting) {
                  if(snapshot.hasData) {
                    return Container(

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
                          SizedBox(height:40,),
                          FooterVB()
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
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading:SizedBox(),
              leadingWidth: 0,
              title: Text("Profile",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
            ),
            body: Padding(
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
                  SizedBox(height: 50),
                  FooterVB()
                ],
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
        ],
      ),
    );
  }
}
