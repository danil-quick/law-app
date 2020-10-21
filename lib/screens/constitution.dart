import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class ConstitutionScreen extends StatefulWidget {
  _ConstitutionScreenState createState() => _ConstitutionScreenState();
}

class _ConstitutionScreenState extends State<ConstitutionScreen> {

  bool isLoading = true;
  List items;
  List<bool> is_visible = <bool>[];
  int items_count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'constitution';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        items_count = items.length;
        for(int i = 0; i<items.length; i++) {
          is_visible.add(false);  
        }
        isLoading = false;
      });
      print('parliament: ${items.toString()}');
    }
  }

  Widget getItemList(String title, String contents, int index) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          setState(() {
            is_visible[index] = !is_visible[index];
            for(int i=0; i<items_count; i++) {
              if(i != index) {
                is_visible[i] = false;
              }
            }
          });
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
                      fontSize: 11
                    ),),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: is_visible[index] ? Icon(Icons.keyboard_arrow_down)
                    : Icon(Icons.chevron_right),
                  ),
                ],
              ),
              is_visible[index] 
              ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Text(contents),
              )
              : Container()
            ],
          )
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
      appBar: AppBar(title: Text('CONSTITUTION'),),
      drawer: AppDrawer(),
      body: isLoading ? Container(
        height: height,
        child: Center(child: CircularProgressIndicator()),
      )
      : ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return getItemList(items[index]['title'], items[index]['contents'], index);
        },
      )
    );
  }
}
