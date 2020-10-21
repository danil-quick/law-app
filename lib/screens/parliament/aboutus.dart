import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class AboutUsScreen extends StatefulWidget {
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  bool isLoading = true;
  List items;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'aboutUs';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('aboutUs: ${items.toString()}');
    }
  }

  Widget getItemList(String title, String description) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
        },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black45
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(title, style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold
                    ),),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Text(description)
              )
            ],
          )
        )
      )
    );
  } 

   @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('ABOUT US')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Header part
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: width,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black26)
                    )
                  ),
                  child: Row(
                    children: [
                      Text('About POSL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
                    ],
                  ),
                )
              ),

              // List view
              isLoading ? Container(
                height: height,
                child: Center(child: CircularProgressIndicator()),
              )
              : 
              items != null ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    for (var item in items)  getItemList(item['title'], item['description'])
                  ],
                ),
              )
              : Container(
                padding: EdgeInsets.only(top: 30),
                child: Text('Not exist file!', style: TextStyle(fontSize: 12, color: Colors.red),),
              )
            ],
          ),
        ),
      )
    );
  }
}
