import 'dart:async';

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:qr_scanner/widgets/qr_scanner/qr_scanner_controller.dart';
import 'package:qr_scanner/widgets/qr_scanner/qr_scanner_preview.dart';

class QRScanner extends StatefulWidget{

  String _title;
  double _scannerSize;
  List<Permission> _permissions;

  QRScanner({@required String title, @required double scannerSize, @required List<Permission> permissions}){

    this._title = title;
    this._scannerSize = scannerSize;
    this._permissions = permissions;

  }

  @override
  QRScannerState createState() => QRScannerState();

}

class QRScannerState extends State<QRScanner> with WidgetsBindingObserver{

  GlobalKey<ScaffoldState> _scaffoldKey;
  Future<void> _initFuture;
  QRScannerController _qrScannerController;

  @override
  void initState(){

    super.initState();

    WidgetsBinding.instance.addObserver(this);

    this._scaffoldKey = GlobalKey<ScaffoldState>();
    this._initFuture = this._init();

  }

  @override
  void dispose(){

    this._dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){

    if(state == AppLifecycleState.resumed){

      setState((){

        this._initFuture = this._init();

      });

    }else if(state == AppLifecycleState.paused){

      this._dispose();

    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      key: this._scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(this.widget._title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: this._initFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){

          Widget widget = Center(
            child: CircularProgressIndicator(),
          );

          if(snapshot.connectionState == ConnectionState.done && !snapshot.hasError){

            widget = QRScannerPreview(this._qrScannerController, this.widget._scannerSize);

          }

          return widget;

        },
      ),
    );

  }

  Future<void> _init() async{

    await this._checkPermissions();
    await this._initQRScannerController();

  }

  Future<void> _dispose() async{

    await this._disposeQRScannerController();

  }

  Future<void> _checkPermissions() async{

    for(Permission permission in this.widget._permissions){

      if(await permission.isUndetermined || await permission.isDenied){

        await permission.request();

      }

    }

  }

  Future<void> _initQRScannerController() async{

    this._qrScannerController = QRScannerController(processQRScanResult, ResolutionPreset.max);

    await this._qrScannerController.initialize();

  }

  Future<void> _disposeQRScannerController() async{

    await this._qrScannerController.dispose();

  }

  void processQRScanResult(List<Barcode> barcodeList){

    if(barcodeList.length > 0){

      this._scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(barcodeList.first.rawValue)));

    }

  }

}
