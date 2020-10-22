import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:qr_scanner/screens/qr_scanner.dart';

void main(){

  runApp(
    MaterialApp(
      home: QRScanner(
        title: 'QR Scanner',
        scannerSize: 0.6,
        permissions: <Permission>[
          Permission.storage,
          Permission.camera,
        ],
      ),
    ),
  );

}
