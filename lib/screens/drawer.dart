import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image:  AssetImage('assets/images/header_drawer.jpg')
              )
            ),
            child: Stack(children: <Widget>[
              Positioned(
                bottom: 12.0,
                left: 16.0,
                child: Text("Parliament App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  )
                )
              ),
            ])
          ),
          ListTile(
            title: Text('Menu', style: TextStyle(color: Colors.black54),),
            onTap: () {},
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.home),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('HOME'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/homeScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.home),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('PARLIAMENT'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/parliamentScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.file_download),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('DOWNLOADS'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/downloadsScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.message),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('ONLINE FORUM'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/onlineForumScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.poll),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('VOTES'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/votesScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.book),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('STANDING ORDER'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/standingOrderScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.library_books),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('CONSTITUTION'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/constitutionScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.speaker_notes),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('STATE OPENING'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/stateOpeningScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.attach_money),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('BUDGET'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/budgetScreen');
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.ondemand_video),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('VIDEO STREAMING'),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/videoStreamingScreen');
            },
          ),
          Divider(),

          ListTile(
            title: Text('Info', style: TextStyle(color: Colors.black54),),
            onTap: () {},
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.call),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('CALL US'),
                )
              ],
            ),
            onTap: () {
              launch("tel://21213123123");
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.star),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Rate App'),
                )
              ],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}