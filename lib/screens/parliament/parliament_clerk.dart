import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class ParliamentClerkScreen extends StatefulWidget {
  _ParliamentClerkScreenState createState() => _ParliamentClerkScreenState();
}

class _ParliamentClerkScreenState extends State<ParliamentClerkScreen> {

  bool isLoading = true;
  List items;
  String imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'parliamentClerk';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        String preUrl = '${GlobalConfiguration().getString('base_url')}';
        imageUrl = preUrl + items[0]['image'];
        isLoading = false;
      });
      print('parliamentClerk: ${items.toString()}');
      print(imageUrl);
    }
  } 

   @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('PARLIAMENT'),),
      drawer: AppDrawer(),
      body: isLoading ? Container(
        height: height,
        child: Center(child: CircularProgressIndicator()),
      )
      : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Header part
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: width,
                  child: Row(
                    children: [
                      Text('Clerk of Parliament', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                )
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: 160.0,
                height: 160.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(color: Colors.black),
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(imageUrl)
                  )
                )
              ),
              Text(items[0]['name'] != null ?items[0]['name'] : ''),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[0]['description'] != null ?items[0]['description'] : ''),
                    SizedBox(height: 10.0,),
                    Text('EDUCATION', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(items[0]['education'] != null ?items[0]['education'] : ''),
                    SizedBox(height: 10.0,),
                    Text('EXPERIENCE', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(items[0]['experience'] != null ?items[0]['experience'] : ''),
                    SizedBox(height: 10.0,),
                    Text('SKILLS AND TRAININGS', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(items[0]['skills_trainings'] != null ?items[0]['skills_trainings'] : ''),
                    SizedBox(height: 10.0,),
                    Text('ACTIVITIES AND COMMUNITY SERVICE', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(items[0]['activities_community_service'] != null ?items[0]['activities_community_service'] : ''),
                    SizedBox(height: 10.0,),
                    items[0]['mobile'] != null ? Row(
                      children: [
                        Text('Mobile: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(items[0]['mobile'])
                      ],
                    ): Container(),
                    items[0]['email'] != null ? Row(
                      children: [
                        Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(items[0]['email'])
                      ],
                    ): Container()
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
