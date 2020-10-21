import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:law_app/screens/drawer.dart';

class ResearchMaterialsScreen extends StatefulWidget {
  _ResearchMaterialsScreenState createState() => _ResearchMaterialsScreenState();
}

class _ResearchMaterialsScreenState extends State<ResearchMaterialsScreen> {

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
    final String url = baseUrl + 'researchMaterials';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('researchMaterials: ${items.toString()}');
    }
  }

  Future _searchData(String key) async {
    setState(() {
      isLoading = true;
    });
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'searchResearchMaterials';
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
      print('searchResearchMaterials: ${items.toString()}');
    }
  }

  Future downloadFile(String fileName, String filePath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String autdiopath = '${dir.path}/' + fileName;
    String baseUrl = '${GlobalConfiguration().getString('base_url')}';
    String audiourl = baseUrl+ filePath;
    print(audiourl);
    print(autdiopath);
    File audiofile = new File(autdiopath);
    if(!audiofile.existsSync()) {
      Dio dio = Dio();

      dio.download(
        audiourl,
        autdiopath,
        onReceiveProgress: (rcv, total) {
          if(rcv == total){
            print('success');
          }
        },
        deleteOnError: true,
      ).then((_) {
      });
    } else {
      print('Already exist this file!!!!!!!!!!');
    }
  }

  Widget getItemList(String title, String filePath, String fileName) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: Container(
        padding: EdgeInsets.all(0),
        width: width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black38
            )
          )
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              width: width,
              child: Row(
                children: [
                  Text(title, style: TextStyle(
                    fontSize: 12
                  ),)
                ],
              )
            ),
            GestureDetector(
              onTap: () {
                downloadFile(fileName, filePath);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0),
                width: width,
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file, color: Colors.blue, size: 20,),
                    Text('View/Download File', style: TextStyle(
                      fontSize: 12, decoration: TextDecoration.underline, color: Colors.blue
                    ),)
                  ],
                )
              ),
            )
          ],
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
                      Text('PARLIAMENTARY RESEARCH')
                    ],
                  ),
                )
              ),

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
                  return getItemList(items[index]['title'], items[index]['file_path'], items[index]['file_name']);
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
