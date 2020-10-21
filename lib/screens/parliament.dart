import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class ParliamentScreen extends StatefulWidget {
  _ParliamentScreenState createState() => _ParliamentScreenState();
}

class _ParliamentScreenState extends State<ParliamentScreen> {

  bool isLoading = true;
  List items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'parliament';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('parliament: ${items.toString()}');
    }
  }

  Widget getItemList(String title, String subTitle, String key) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    String nextUrl;
    switch (key) {
      case "001":
        nextUrl = "/aboutUsScreen";
        break;
      case "002":
        nextUrl = "/parliamentMembersScreen";
        break;
      case "014":
        nextUrl = "/parliamentCalendarScreen";
        break;
      case "016":
        nextUrl = "/parliamentChiefMembersScreen";
        break;
      case "017":
        nextUrl = "/parliamentSpeakerScreen";
        break;
      case "018":
        nextUrl = "/parliamentClerkScreen";
        break;
      case "019":
        nextUrl = "/parliamentDirectoryScreen";
        break;
      default:
        nextUrl = "/parliamentScreen";
        break;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(nextUrl);
        },
        child: Container(
          height: 45,
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
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                height: 45,
                width: 60,
                color: Colors.black12,
                child: Text(title, style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11
                ), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.all(8),
                height: 45,
                width: width-100,
                child: Text(subTitle, style: TextStyle(
                  fontSize: 11
                ),),
              ),
            ],
          ),
        ),
      ),
    );
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
      : ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return getItemList(items[index]['title'], items[index]['subtitle'], items[index]['key']);
        },
      )
    );
  }
}
