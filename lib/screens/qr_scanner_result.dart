import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_scanner/utils/permission.dart' as permission_utils;

class QRScannerResult extends StatefulWidget{

  String _title;
  String _qrContent;
  List<Permission> _permissions;

  QRScannerResult({@required String title, @required String qrContent, @required List<Permission> permissions}){

    this._title = title;
    this._qrContent = qrContent;
    this._permissions = permissions;

  }

  @override
  QRScannerResultState createState() => QRScannerResultState();

}

class QRScannerResultState extends State<QRScannerResult>{

  bool _inited;
  Future<void> _initFuture;

  @override
  void initState(){

    super.initState();

    this._inited = false;
    this._initFuture = this._init();

  }

  @override
  void dispose(){

    super.dispose();

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget._title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  this.widget._qrContent,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 32.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 64.0,
                            height: 64.0,
                            margin: EdgeInsets.only(
                              bottom: 4.0,
                            ),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.open_in_browser),
                                color: Theme.of(context).bottomAppBarColor,
                                iconSize: 32.0,
                                splashRadius: 32.0,
                                onPressed: () async{

                                  if(await canLaunch(this.widget._qrContent)){

                                    await launch(this.widget._qrContent);

                                  }

                                },
                              ),
                            ),
                          ),
                          Text(
                            'Open',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 64.0,
                            height: 64.0,
                            margin: EdgeInsets.only(
                              bottom: 4.0,
                            ),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.content_copy),
                                color: Theme.of(context).bottomAppBarColor,
                                iconSize: 32.0,
                                splashRadius: 32.0,
                                onPressed: (){

                                  Clipboard.setData(ClipboardData(
                                    text: this.widget._qrContent,
                                  ));

                                },
                              ),
                            ),
                          ),
                          Text(
                            'Copy',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Future<void> _init() async{

    await permission_utils.checkPermissions(this.widget._permissions);

    this._inited = true;

  }

}
