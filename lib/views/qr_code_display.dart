import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRDisplayPage extends StatefulWidget {
  const QRDisplayPage({super.key});
  
  @override
  QRDisplayPageState createState() => QRDisplayPageState();
}


class QRDisplayPageState extends State<QRDisplayPage> {

  String _accessToken = '';
  int _institutionId = -1;
  String qrData = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }
   _loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _institutionId = prefs.getInt('institutionId') ?? -1;
      _accessToken = prefs.getString('accessToken') ?? '';
      final encodedAccessToken = base64Encode(utf8.encode(_accessToken));
      final encodedInstitutionId = base64Encode(utf8.encode(_institutionId.toString()));
      qrData = jsonEncode({"accessToken": encodedAccessToken, "institutionId": encodedInstitutionId});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR kód môjho tímu'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: qrData.isNotEmpty
            ? QrImage(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }


  
}