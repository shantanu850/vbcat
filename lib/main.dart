import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inspired_catering/components/footer.dart';
import 'package:inspired_catering/home.dart';
import 'package:inspired_catering/login.dart';
import 'package:inspired_catering/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'ic', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp( MaterialApp(home: Loader(),
    theme: ThemeData(
      fontFamily: 'proxima'
    ),
    debugShowCheckedModeBanner:false,)
  );
}

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  Future<bool> ff;
  Future<bool> getUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('loged');
  }
  @override
  void initState() {
    ff = getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ff,
      builder: (context, snapshot) {
        if(snapshot.connectionState!=ConnectionState.waiting) {
          if (snapshot.data != null) {
            if (snapshot.data) {
              return HomeScreen();
            } else {
              return Auth();
            }
          } else {
            return Auth();
          }
        }else{
          return Material(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/splash.png'),fit: BoxFit.fitWidth)
                ),
              )
          );
        }
      }
    );
  }
}


class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20),
              child: Image(image: AssetImage('assets/images/favicon.png'),height:120,),
            ),
            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:width*0.05),
                child: Card(
                  color: Colors.amber,
                  child: Container(
                    width:width,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("REGISTER",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: width*0.4,
                      child: Divider(height:2,color:Colors.grey,)),
                  Text("  OR  ",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                  Container(
                      width: width*0.4,
                      child: Divider(height:2,color:Colors.grey,)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Already a user ?",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,fontSize:16),textAlign:TextAlign.center,),
            ),
            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScrren())),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:width*0.05),
                child: Card(
                  color: Colors.grey[200],
                  child: Container(
                    width:width,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("SIGN IN",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w600),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:0,vertical:10),
              child: Image(image: AssetImage('assets/images/logo.jpeg'),height:120,),
            ),
            Divider(height:2,color:Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0),
              child: Text("Copyright 2020 Inspired Catering - All Rights Reserved",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400),textAlign:TextAlign.center,),
            ),
            FooterVB()
          ],
        ),
      ),
    );
  }
}

