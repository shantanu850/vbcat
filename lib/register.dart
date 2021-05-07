import 'package:flutter/material.dart';
import 'package:inspired_catering/components/footer.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Register",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:0.0,horizontal:20.0),
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
            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height:90,
        child: FooterVB(),
      ),
    );
  }
}
