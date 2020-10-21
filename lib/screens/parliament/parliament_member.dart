import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class ParliamentMemberScreen extends StatefulWidget {
  const ParliamentMemberScreen(this.id);

  final String id;
  _ParliamentMemberScreenState createState() => _ParliamentMemberScreenState();
}

class _ParliamentMemberScreenState extends State<ParliamentMemberScreen> {

  bool isLoading = true;
  List items;
  String imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'parliamentMember';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: {"id": widget.id}
    );

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        String preUrl = '${GlobalConfiguration().getString('base_url')}';
        imageUrl = preUrl + items[0]['image'];
        isLoading = false;
      });
      print('parliamentMember: ${items.toString()}');
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
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black26)
                    )
                  ),
                  child: Row(
                    children: [
                      Text(items[0]['name'], style: TextStyle(fontWeight: FontWeight.bold),),
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
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[0]['description'] != null ?items[0]['description'] : ''),
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
