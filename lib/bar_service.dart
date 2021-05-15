import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspired_catering/components/api.dart';

import 'components/custom_dropdown.dart';

class BarServices extends StatefulWidget {
  const BarServices({Key key}) : super(key: key);

  @override
  _BarServicesState createState() => _BarServicesState();
}

class _BarServicesState extends State<BarServices> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,), onPressed: ()=>Navigator.pop(context)),
        title: Text("Bar Packages",style: TextStyle(fontFamily:"proxima",fontWeight:FontWeight.w400,color:Colors.green)),
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
              style: TextStyle(fontWeight: FontWeight.bold,
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
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8))
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    image: DecorationImage(image: NetworkImage(
                                        "${snapshot
                                            .data[index]["image"]["src"]}"),
                                        fit: BoxFit.cover)
                                ),
                              ),
                              ListTile(
                                title: Text("${snapshot.data[index]["name"]}",
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,),
                                subtitle: Text(
                                  "${snapshot.data[index]["description"]}",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Colors.black),),
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
