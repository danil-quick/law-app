import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = true;
  List homeList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'home';
    print(url);
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        homeList = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('home: ${homeList.toString()}');
    } else {
      print('error: server');
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
      case "003":
        nextUrl = "/standingOrderScreen";
        break;
      case "004":
        nextUrl = "/constitutionScreen";
        break;
      case "005":
        nextUrl = "/videoStreamingScreen";
        break;
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
      case "010":
        nextUrl = "/votesScreen";
        break;
      case "011":
        nextUrl = "/researchMaterilasScreen";
        break;
      case "012":
        nextUrl = "/budgetScreen";
        break;
      case "013":
        nextUrl = "/stateOpeningScreen";
        break;
      case "014":
        nextUrl = "/parliamentCalendarScreen";
        break;
      default:
        nextUrl = "/homeScreen";
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
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('HOME')),
      drawer: AppDrawer(),
      body: isLoading ? Container(
        height: height,
        child: Center(child: CircularProgressIndicator()),
      )
      : ListView.builder(
        itemCount: homeList.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return getItemList(homeList[index]['title'], homeList[index]['subtitle'], homeList[index]['key']);
        },
      )
    );
  }
}
