import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:flutter_rocnikovy/data/institution.dart';
import 'package:flutter_rocnikovy/data/institution_details.dart';
import 'package:flutter_rocnikovy/data/user.dart';
import 'package:flutter_rocnikovy/views/users_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTeamPage extends StatefulWidget{

 final int teamId;
 final bool scannedFlag;

  // Constructor
  MyTeamPage({required this.teamId, required this.scannedFlag});

  @override
  State<StatefulWidget> createState() => MyTeamPageState();

}

class MyTeamPageState extends State<MyTeamPage>{
  int teamId = -1;
  String _institutionName = '';
  String _institutionSportName = '';
  String pageHeader = 'Môj tím';
  String scannedPageHeader = 'Detaily tímu';
  List<User> _allUsers = [];
  List<User> _foundUsers= [];
  bool scannedFlag = false;
  API _api = API();
  
  @override
  void initState(){
    super.initState();
    teamId = widget.teamId;
    scannedFlag = widget.scannedFlag;
    _loadTeamData();
  }


  _loadTeamData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _institutionName = prefs.getString('institutionName') ?? '';
      _institutionSportName = prefs.getString('institutionSportName') ?? '';
      teamId == prefs.getInt('institutionId') ? pageHeader = 'Môj tím' : pageHeader = 'Detaily o tíme';
    });
  }

  void _searchFilter(String key){
    List<User> results =[];
    if(key.isEmpty){
      results = _allUsers;
    } else{
      results = _allUsers.where((u) => u.firstName!.toLowerCase().contains(key.toLowerCase()) || u.lastName!.toLowerCase().contains(key.toLowerCase())).toList();
    }
    setState((){
      _foundUsers = results;
    });
  }

 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: scannedFlag ? true : false,
      title:  scannedFlag ? Text(scannedPageHeader) : Text(pageHeader)
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _institutionName,
            style: const TextStyle(
              fontSize: 24.0, // set a larger font size
              fontWeight: FontWeight.bold, // make it bold
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _institutionSportName,
            style: const TextStyle(
              fontSize: 18.0, // smaller than _institutionName
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(
          color: Colors.black,
          height: 1.0,
          thickness: 1.0,
        ),
        Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          onChanged: (value) => _searchFilter(value),
          decoration: const InputDecoration(
          labelText:'Meno alebo Priezvisko',
          suffixIcon: Icon(Icons.search)
        ),
         ),
          ),
           Expanded(
             child: FutureBuilder<dynamic>(
              future: _api.getInstitutionDetails(teamId),
              builder:(context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(  
                    child: CircularProgressIndicator()
                  );
                } else if(snapshot.hasData){
                  InstitutionDetails instDetails = snapshot.data!;
                  List<User> users = instDetails.members!;
                  if(_allUsers.isEmpty){
                   _allUsers = users;
                  _foundUsers = users;
                  }
                  return buildUsers(_foundUsers);
                } else{
                  return const Text('Žiadny hráči sa nenašli');
                }
              }),
           ),
      ],
    ),
  );
}

 Widget buildUsers(List<User> users) => Scrollbar(
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                            child: ListTile(
                                title: Text("${user.firstName} ${user.lastName}"),
                                subtitle: Text("${user.institutionName}"),
                                trailing: const Icon(Icons.navigate_next),
                                onTap: () {
                                   Navigator.of(context).pushNamed('/homePage/userDetails', arguments: user.id!);
                                },
                            ),
                        );
                    },
  ),
            
);

}