import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:flutter_rocnikovy/views/my_team_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QRScanPage extends StatefulWidget {
  final ValueNotifier<int> currentIndexNotifier;

  QRScanPage({Key? key, required this.currentIndexNotifier}) : super(key: key);

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isActiveTab = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.currentIndexNotifier,
      builder: (context, value, child) {
        _isActiveTab = (value == 1); // QRScanPage is the active tab if value == 1

        if (_isActiveTab) { // if QRScanPage is the active tab, resume the camera
          controller?.resumeCamera();
        } else { // otherwise, pause the camera
          controller?.pauseCamera();
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Skener'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    API _api = API();
    this.controller = controller;
    if (_isActiveTab) { // if QRScanPage is the active tab, start scanning
      controller.resumeCamera();
    } else { // otherwise, pause the camera
      controller.pauseCamera();
    }
    controller.scannedDataStream.listen((scanData) async {
      if (_isActiveTab) { // only process scan results if QRScanPage is the active tab
        try {
          await _processScanData(scanData);
        } catch (e) {
          controller.pauseCamera();
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Nič sa nenašlo'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Neplatný QR kód'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.resumeCamera();
                  },
                ),
              ],
            );
          },
        );
      }
    }
   });
}


  Future<void> _processScanData(Barcode scanData) async {
    Map<String, dynamic> data = jsonDecode(scanData.code!);
    if (data.containsKey('accessToken') && data.containsKey('institutionId')) {
      // pause the camera before navigating to the new page
      controller!.pauseCamera();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyTeamPage(teamId: data['institutionId'], scannedFlag: true,),
        ),
      ).then((_) => controller!.resumeCamera()
      );
    } 
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
