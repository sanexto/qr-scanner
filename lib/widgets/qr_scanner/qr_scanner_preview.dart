import 'package:flutter/material.dart';

import 'package:flutter_better_camera/camera.dart';

import 'package:qr_scanner/widgets/qr_scanner/qr_scanner_controller.dart';

class QRScannerPreview extends StatefulWidget{

  QRScannerController _qrScannerController;
  double _scannerSize;

  QRScannerPreview(QRScannerController qrScannerController, double scannerSize) : super(){

    this._qrScannerController = qrScannerController;
    this._scannerSize = scannerSize;

  }

  @override
  QRScannerPreviewState createState() => QRScannerPreviewState();

}

class QRScannerPreviewState extends State<QRScannerPreview>{

  @override
  Widget build(BuildContext context){

    return Stack(
      children: <Widget>[
        CameraPreview(this.widget._qrScannerController.cameraController),
        ClipPath(
          child: Container(
            color: Colors.black54,
          ),
          clipper: QRScannerPreviewClipper(this.widget._scannerSize),
        ),
      ],
    );

  }

}

class QRScannerPreviewClipper extends CustomClipper<Path>{

  double _scannerSize;

  QRScannerPreviewClipper(double scannerSize) : super(){

    this._scannerSize = scannerSize;

  }

  @override
  Path getClip(Size size){

    double containerWidth = size.width;
    double containerHeight = size.height;
    double scannerWidth = containerHeight > containerWidth ? containerWidth * this._scannerSize : containerHeight * this._scannerSize;
    double scannerHeight = scannerWidth;
    double availableWidth = containerWidth - scannerWidth;
    double availableHeight = containerHeight - scannerHeight;

    Path path = Path()
      ..addRect(Rect.fromLTRB(0, 0, (availableWidth / 2), containerHeight))
      ..addRect(Rect.fromLTRB((availableWidth / 2) + scannerWidth, 0, containerWidth, containerHeight))
      ..addRect(Rect.fromLTRB(0, 0, containerWidth, (availableHeight / 2)))
      ..addRect(Rect.fromLTRB(0, (availableHeight / 2) + scannerHeight, containerWidth, containerHeight));

    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}
