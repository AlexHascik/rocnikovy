import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:flutter_rocnikovy/data/institution_details.dart';
import 'package:flutter_rocnikovy/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTeamPage extends StatefulWidget{

 final int teamId;
 final bool scannedFlag;

  const MyTeamPage({super.key, required this.teamId, required this.scannedFlag});

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
  final API _api = API();
  
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

  void _updateUserList() async {
  InstitutionDetails instDetails = await _api.getInstitutionDetails(teamId, );
  List<User> users = instDetails.members!;
  setState(() {
    _allUsers = users;
    _foundUsers = users;
  });
}

 @override
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
         scannedFlag ? const Padding(padding: EdgeInsets.all(0),) : 
         Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Card(  
            child: ListTile( 
              title: const Text("Zoznam obĺúbených hráčov"),
              trailing: const Icon(Icons.navigate_next),
              onTap: () async { 
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String>? favorites = prefs.getStringList('favoritePlayerIds');
              int size= 0;
              if(favorites != null){
                print('tu');
                size = favorites.length;
              }
              print(size);
               var result = await Navigator.of(context).pushNamed('/homePage/favoritePlayers');
               favorites = prefs.getStringList('favoritePlayerIds');
               int newSize = 0;
               if(favorites != null){
                newSize = favorites.length;
               }
                print(newSize);

               if(result == 'update' && newSize < size){
                  _updateUserList();
               }
                
              }
            ),
          ), 
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
                  return UserList(users: _foundUsers);
                } else{
                  return const Text('Žiadny hráči sa nenašli');
                }
              }),
           ),
      ],
    ),
  );
}
}

class UserList extends StatelessWidget {
  final List<User> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserListItem(user: user);
        },
      ),
    );
  }
}

class UserListItem extends StatefulWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  UserListItemState createState() => UserListItemState();
}

class UserListItemState extends State<UserListItem> {
  bool starSelected = false;

  @override
  void initState() {
    super.initState();
    _getFavoriteState();
  }

  Future<void> _getFavoriteState() async {
    final favoritePlayerIds = await _getFavoritePlayerIds();
    setState(() {
      starSelected = favoritePlayerIds.contains(widget.user.id.toString());
    });
  }

  Future<List<String>> _getFavoritePlayerIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favoritePlayerIds') ?? [];
  }

  Future<void> _setFavoriteState(bool favorite) async {
    final favoritePlayerIds = await _getFavoritePlayerIds();
    final updatedFavoritePlayerIds = List<String>.from(favoritePlayerIds);

    if (favorite) {
      updatedFavoritePlayerIds.add(widget.user.id.toString());
    } else {
      updatedFavoritePlayerIds.remove(widget.user.id.toString());
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoritePlayerIds', updatedFavoritePlayerIds);

    setState(() {
      starSelected = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("${widget.user.firstName} ${widget.user.lastName}"),
        subtitle: Text("${widget.user.institutionName}"),
        trailing: GestureDetector(
          onTap: () {
            _setFavoriteState(!starSelected);
          },
          child: Icon(
            Icons.star,
            color: starSelected ? Colors.yellow : null,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/homePage/userDetails', arguments: widget.user.id!);
        },
      ),
    );
  }
}


