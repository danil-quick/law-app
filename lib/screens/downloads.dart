import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class DownloadsScreen extends StatefulWidget {
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {

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
    final String url = baseUrl + 'downloads';
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
      case "006":
        nextUrl = "/gazettedActsScreen";
        break;
      case "007":
        nextUrl = "/govtAgreementScreen";
        break;
      case "008":
        nextUrl = "/officialReportScreen";
        break;
      case "009":
        nextUrl = "/committeesReportsScreen";
        break;
      case "011":
        nextUrl = "/researchMaterilasScreen";
        break;
      default:
        nextUrl = "/downloadsScreen";
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
      appBar: AppBar(title: Text('DOWNLOADS'),),
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
