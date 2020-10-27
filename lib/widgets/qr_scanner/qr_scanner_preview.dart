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

class QRScannerPreviewState extends State<QRScannerPreview> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState(){

    super.initState();

    this._initAnimation();

  }

  @override
  void dispose(){

    this._disposeAnimation();

    super.dispose();

  }

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
        FadeTransition(
          opacity: this._animation,
          child: Center(
            child: Container(
              width: double.infinity,
              height: 1.0,
              margin: EdgeInsets.symmetric(
                horizontal: 64 * this.widget._scannerSize,
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );

  }

  void _initAnimation(){

    this._animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    this._animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(this._animationController);

    this._animationController.repeat(
      reverse: true,
    );

  }

  void _disposeAnimation(){

    this._animationController.dispose();

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
