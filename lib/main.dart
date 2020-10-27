import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:qr_scanner/screens/qr_scanner.dart';

void main(){

  runApp(
    MaterialApp(
      home: QRScanner(
        title: '',
        scannerSize: 0.7,
        permissions: <Permission>[
          Permission.storage,
          Permission.camera,
        ],
      ),
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );

}
