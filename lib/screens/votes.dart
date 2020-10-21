import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class VotesScreen extends StatefulWidget {
  _VotesScreenState createState() => _VotesScreenState();
}

class _VotesScreenState extends State<VotesScreen> {

  List<LeaderBoard> list = <LeaderBoard>[];
  LeaderBoard _selectedItem;
  bool isLoading = true;
  bool isvoting = false;
  bool isvoteResult = false;
  List items;
  List voteResult;
  int _radioValue;
  int sum_yes;
  int sum_no;
  int sum_not_sure;
  int total;

  void _handleRadioValueChange(int value) {  
    setState(() {
      _radioValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'votes';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      for(int i = 0; i<items.length; i++) {
        list.add(LeaderBoard(items[i]['title'], items[i]['topics'], items[i]['id'], items[i]['sum_yex'], items[i]['sum_no'], items[i]['sum_not_sure']));  
      }
      print('votes: ${items.toString()}');
      print('votes: ${list.toString()}');
    }
  }

  Future _vote(int id) async {
    setState(() {
      isvoting = true;
    });
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'vote';
    final client = new http.Client();
    if (_radioValue == null) _radioValue = -1;
    print('radioValue= ${_radioValue.toString()}');
    print(url);
    final response = await client.post(
      url,
      body: {
        'id': id.toString(),
        'vote_type': _radioValue.toString()
      }
    );
    if (response.statusCode == 200) {
      setState(() {
        _radioValue = null;
        voteResult = null;
        isvoting = false;
      });
    } else {
      print('error------------------------------');
    }
  }

  Future _getVote(int id) async {
    setState(() {
      isvoteResult = true;
    });
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'voteResult';
    final client = new http.Client();
    final response = await client.post(
      url,
      body: {
        'id': id.toString()
      }
    );
    
    if (response.statusCode == 200) {
      setState(() {
        voteResult = json.decode(response.body)['data'];
        sum_yes = voteResult[0]['sum_yes'];
        sum_no = voteResult[0]['sum_no'];
        sum_not_sure = voteResult[0]['sum_not_sure'];
        total = sum_yes + sum_no + sum_not_sure;
        isvoteResult = false;
      });
      print('voteResult: ${voteResult.toString()}');
    } else {
      print('error------------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VOTES'),),
      drawer: AppDrawer(),
      body: isLoading ? Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: CircularProgressIndicator()),
      )
      : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black26)
                      )
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width-100,
                          child: Text('Vote Finder', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Row(children: [
                    Text('Select Vote Topic', style: TextStyle(
                      fontSize: 11
                    ),)
                  ],)
                ],
              )
            ),
            SearchWidget<LeaderBoard>(
              dataList: list,
              hideSearchBoxWhenItemSelected: false,
              listContainerHeight: MediaQuery.of(context).size.height / 4,
              queryBuilder: (query, list) {
                return list
                    .where((item) => item.title
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              },
              popupListItemBuilder: (item) {
                return PopupListItemWidget(item);
              },
              selectedItemBuilder: (selectedItem, deleteSelectedItem) {
                return SelectedItemWidget(selectedItem, deleteSelectedItem);
              },
              // widget customization
              noItemsFoundWidget: NoItemsFound(),
              textFieldBuilder: (controller, focusNode) {
                return MyTextField(controller, focusNode);
              },
              onItemSelected: (item) {
                setState(() {
                  _selectedItem = item;
                  voteResult = null;
                });
              },
            ),
            _selectedItem == null ? const SizedBox(
              height:  32,
            ) : Container(),
            _selectedItem != null ? Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                              activeColor: Colors.blue,
                            ),
                            Text('Yes')
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                              activeColor: Colors.blue,
                            ),
                            Text('No')
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                              activeColor: Colors.blue,
                            ),
                            Text('Not Sure')
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          _vote(_selectedItem.id);
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: isvoting ? CircularProgressIndicator()
                        : Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text('VOTE', style: TextStyle(fontSize: 14)),
                          )
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _getVote(_selectedItem.id);
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: isvoteResult ? CircularProgressIndicator()
                        : Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text('VIEW RESULT', style: TextStyle(fontSize: 14)),
                          )
                        ),
                      ),
                    ],
                  ),
                  voteResult != null ? Container(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Column(
                      children: [
                        SizedBox(height: 6.0,),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('YES', style: TextStyle(fontSize: 14)),
                                  Text(': ', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-200,
                              height: 18,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.4)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: total != 0 ? (MediaQuery.of(context).size.width-200.8)*sum_yes/total : 0,
                                    height: 18,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 6.0,),
                            Text('$sum_yes/$total', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 6.0,),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('NO', style: TextStyle(fontSize: 14)),
                                  Text(': ', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-200,
                              height: 18,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.4)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: total != 0 ? (MediaQuery.of(context).size.width-200.8)*sum_no/total : 0,
                                    height: 18,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 6.0,),
                            Text('$sum_no/$total', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 6.0,),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('NOT SURE', style: TextStyle(fontSize: 14)),
                                  Text(': ', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-200,
                              height: 18,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.4)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: total != 0 ? (MediaQuery.of(context).size.width-200.8)*sum_not_sure/total : 0,
                                    height: 18,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 6.0,),
                            Text('$sum_not_sure/$total', style: TextStyle(fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  )
                  : Container()
                ],
              )
            )
            : Text(
              "No topic selected",
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderBoard {
  LeaderBoard(this.title, this.topics, this.id, this.yes, this.no, this.notSure);

  final String title;
  final String topics;
  final int id;
  final int yes;
  final int no;
  final int notSure;
}

class SelectedItemWidget extends StatefulWidget {
  const SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final LeaderBoard selectedItem;
  final VoidCallback deleteSelectedItem;
  _SelectedItemWidgetState createState() => _SelectedItemWidgetState();
}

class _SelectedItemWidgetState extends State<SelectedItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    widget.selectedItem.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 22),
                color: Colors.grey[700],
                onPressed: widget.deleteSelectedItem,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              widget.selectedItem.topics,
            ),
          )
        ],
      ),
    );
  }
}


class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Items Found",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final LeaderBoard item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
