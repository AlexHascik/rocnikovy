import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:flutter_rocnikovy/data/institution_details.dart';
import 'package:flutter_rocnikovy/views/my_team_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QRScanPage extends StatefulWidget {
  final ValueNotifier<int> currentIndexNotifier;

  const QRScanPage({Key? key, required this.currentIndexNotifier}) : super(key: key);

  @override
  QRScanPageState createState() => QRScanPageState();
}

class QRScanPageState extends State<QRScanPage> {
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
        _isActiveTab = (value == 1); 

        if (_isActiveTab) {
          controller?.resumeCamera();
        } else {
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
    this.controller = controller;
    if (_isActiveTab) {
      controller.resumeCamera();
    } else { 
      controller.pauseCamera();
    }
    controller.scannedDataStream.listen((scanData) async {
      if (_isActiveTab) { 
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
    API api = API();
    Map<String, dynamic> data = jsonDecode(scanData.code!);
    if(!data.containsKey('accessToken') || !data.containsKey('institutionId')) return;
    
    controller!.pauseCamera();    
    var institutionId = decodeBase64(data['institutionId']);
    try{
      int id = int.parse(institutionId);
      InstitutionDetails details = await api.getInstitutionDetails(int.parse(decodeBase64(data['institutionId'])));
    } catch(_){
      controller!.resumeCamera();
    }

     Navigator.of(context).push(
       MaterialPageRoute(
         builder: (context) => MyTeamPage(teamId: int.parse(decodeBase64(data['institutionId'])), scannedFlag: true,),
       ),
     ).then((_) => controller!.resumeCamera()
     );    
  }

  String decodeBase64(String encodedString) {
    final decodedBytes = base64Decode(encodedString);
    return utf8.decode(decodedBytes);
  } 

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
