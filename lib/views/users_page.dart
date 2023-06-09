import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user.dart';

class UsersPage extends StatefulWidget{
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage>{

  API _api = API();
  List<User> _allUsers = [];
  List<User> _foundUsers= [];
  int _teamId = -1;

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

  @override
  void initState(){
    super.initState();
    _loadTeamData();
  }


  _loadTeamData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _teamId = prefs.getInt('institutionId') ?? -1;
    });
  }

  
  @override
   Widget build(BuildContext context){
  

    return Column(  
        children: [
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
              future: _api.getInstitutionDetails(_teamId),
              builder:(context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(  
                    child: CircularProgressIndicator()
                  );
        
                } else if(snapshot.hasData){
                  final users = snapshot.data!;
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
      ]);
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
                                    
                                },
                            ),
                        );
                    },
                ),
            
        );

}