import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/views/my_team_page.dart';
import 'package:flutter_rocnikovy/views/qr_code_display.dart';
import 'package:flutter_rocnikovy/views/qr_scanner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String homeLabel = 'Môj tím';
  String favoritePlayersLabel = 'Skener';
  String myProfileLabel = 'Zdieľanie';

  Icon homeIcon = const Icon(Icons.people);
  Icon favoriteIcon = const Icon(Icons.camera_alt_rounded);
  Icon profileIcon = const Icon(Icons.qr_code);

  final currentIndexNotifier = ValueNotifier<int>(0);

  int _currentIndex = 0;
  int? teamId;

  @override
  void initState() {
    super.initState();
    getTeamId().then((value) => setState(() {
      teamId = value;
    }));
  }

  Future<int> getTeamId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('institutionId') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          teamId != null
            ? MyTeamPage(teamId: teamId!, scannedFlag: false,)
            :const Center(child: CircularProgressIndicator()),
          QRScanPage(currentIndexNotifier: currentIndexNotifier),
          teamId != null
            ? QRDisplayPage()
            : const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: (index) {
          currentIndexNotifier.value = index;
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: homeIcon,
            label: homeLabel,
          ),
          BottomNavigationBarItem(
            icon: favoriteIcon,
            label: favoritePlayersLabel,
          ),
          BottomNavigationBarItem(
            icon: profileIcon,
            label: myProfileLabel,
          ),
        ],
      ),
    );
  }
}
