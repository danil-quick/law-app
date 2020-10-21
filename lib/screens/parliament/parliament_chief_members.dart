import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/parliament/parliament_chief_member.dart';
import 'package:law_app/screens/drawer.dart';

class ParliamentChiefMembersScreen extends StatefulWidget {
  _ParliamentChiefMembersScreenState createState() => _ParliamentChiefMembersScreenState();
}

class _ParliamentChiefMembersScreenState extends State<ParliamentChiefMembersScreen> {

  bool isLoading = true;
  List items;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'parliamentChiefMembers';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('parliamentChiefMembers: ${items.toString()}');
    }
  }

  Future _searchData(String key) async {
    setState(() {
      isLoading = true;
    });
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'searchParliamentChiefMembers';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: {"key": key}
    );

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('searchParliamentChiefMembers: ${items.toString()}');
    }
  }

  Widget getItemList(int id, String name, String image, String district, String directory) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    String baseUrl = '${GlobalConfiguration().getString('base_url')}';
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ParliamentChiefMemberScreen(id.toString()),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 6),
        child: Container(
          padding: EdgeInsets.only(bottom: 6),
          width: width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black26
              )
            )
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage('$baseUrl$image'),
              ),
              Container(
                width: width-50,
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold
                    ),),
                    Text('District: $district', style: TextStyle(
                      fontSize: 11
                    ),),
                    Text(directory, style: TextStyle(
                      fontSize: 11
                    ),),
                  ],
                ),
              ),
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
      appBar: AppBar(title: Text('PALIAMENTS'),),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Search part
              Container(
                padding: EdgeInsets.all(10),
                child: Container(                  
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black45
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      hintText: "Search here...",
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 40,
                child: FlatButton(
                  onPressed: () {
                    print('${searchController.text}');
                    _searchData(searchController.text);
                  },
                  color: Colors.red,
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

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
                      Text('Paramount Chief Members of Parliament', style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                )
              ),

              // Download list
              isLoading ? Container(
                height: height,
                child: Center(child: CircularProgressIndicator()),
              )
              : 
              items != null ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return getItemList(items[index]['id'], items[index]['name'], items[index]['image'], items[index]['district'],items[index]['directory']);
                },
              )
              : Container(
                padding: EdgeInsets.only(top: 30),
                child: Text('Not exist file!', style: TextStyle(fontSize: 12, color: Colors.red),),
              )
            ],
          ),
        )
      )
    );
  }
}
