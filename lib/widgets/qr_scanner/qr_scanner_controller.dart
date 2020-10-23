import 'dart:ui';

import 'package:flutter_better_camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class QRScannerController{

  Function(List<Barcode>) _scannerCallback;
  ResolutionPreset _resolutionPreset;
  CameraController _cameraController;

  CameraController get cameraController => this._cameraController;

  QRScannerController(Function(List<Barcode>) scannerCallback, ResolutionPreset resolutionPreset){

    this._scannerCallback = scannerCallback;
    this._resolutionPreset = resolutionPreset;

  }

  Future<void> initialize() async{

    List<CameraDescription> cameraList = await availableCameras();
    this._cameraController = CameraController(cameraList.first, this._resolutionPreset, flashMode: FlashMode.off);

    await this._cameraController.initialize();
    await this._cameraController.startImageStream((CameraImage image) async{

      FirebaseVisionImageMetadata firebaseVisionImageMetadata = FirebaseVisionImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rawFormat: image.format.raw,
        planeData: <FirebaseVisionImagePlaneMetadata>[
          FirebaseVisionImagePlaneMetadata(
            bytesPerRow: image.planes[0].bytesPerRow,
            width: image.planes[0].width,
            height: image.planes[0].height,
          ),
          FirebaseVisionImagePlaneMetadata(
            bytesPerRow: image.planes[1].bytesPerRow,
            width: image.planes[1].width,
            height: image.planes[1].height,
          ),
          FirebaseVisionImagePlaneMetadata(
            bytesPerRow: image.planes[2].bytesPerRow,
            width: image.planes[2].width,
            height: image.planes[2].height,
          ),
        ],
      );

      FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromBytes(image.planes[0].bytes, firebaseVisionImageMetadata);
      BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector(BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));
      List<Barcode> barcodeList = await barcodeDetector.detectInImage(firebaseVisionImage);

      barcodeDetector.close();

      this._scannerCallback(barcodeList);

    });

  }

  Future<void> dispose() async{

    await this._cameraController.stopImageStream();
    await this._cameraController.dispose();

  }

  Future<void> setFlashMode(FlashMode flashMode) async{

    await this._cameraController.setFlashMode(flashMode);

  }

}
