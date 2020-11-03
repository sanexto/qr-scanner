import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_better_camera/camera.dart';

import 'package:qr_scanner/utils/permission.dart' as permission_utils;
import 'package:qr_scanner/utils/ad.dart' as ad_utils;

import 'package:qr_scanner/widgets/qr_scanner/qr_scanner_controller.dart';
import 'package:qr_scanner/widgets/qr_scanner/qr_scanner_preview.dart';

import 'package:qr_scanner/screens/qr_scanner_result.dart';

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

  bool _flashActivated;
  bool _inited;
  Future<void> _initFuture;
  QRScannerController _qrScannerController;

  @override
  void initState(){

    super.initState();

    WidgetsBinding.instance.addObserver(this);

    this._flashActivated = false;
    this._inited = false;
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

    if(this._inited){

      if(state == AppLifecycleState.resumed){

        setState((){

          this._initFuture = this._init();

        });

      }else if(state == AppLifecycleState.paused){

        this._dispose();

      }

    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(this.widget._title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: this._flashActivated ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
            onPressed: this._onPressFlashButton,
          )
        ],
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

    await permission_utils.checkPermissions(this.widget._permissions);
    await ad_utils.showBannerAd();

    this._qrScannerController = QRScannerController(processQRScannerResult, ResolutionPreset.max);

    await this._qrScannerController.initialize();
    await this._qrScannerController.startImageStream();

    this._inited = true;

  }

  Future<void> _dispose() async{

    await this._qrScannerController.stopImageStream();
    await this._qrScannerController.dispose();

  }

  Future<void> processQRScannerResult(String qrContent) async{

    if(qrContent.isNotEmpty){

      if(this._flashActivated){

        await this._onPressFlashButton();

      }

      await Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (BuildContext context) => QRScannerResult(
            title: 'Result',
            qrContent: qrContent,
            permissions: <Permission>[],
          ),
        ),
      );

    }

    this._qrScannerController.resumeImageStream();

  }

  Future<void> _onPressFlashButton() async{

    if(this._inited){

      if(this._flashActivated){

        await this._qrScannerController.setFlashMode(FlashMode.off);

        this._flashActivated = false;

      }else{

        await this._qrScannerController.setFlashMode(FlashMode.torch);

        this._flashActivated = true;

      }

      setState((){});

    }

  }

}
