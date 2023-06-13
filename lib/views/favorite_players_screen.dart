import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:flutter_rocnikovy/data/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePlayersScreen extends StatefulWidget {
  const FavoritePlayersScreen({super.key});

  @override
  State<FavoritePlayersScreen> createState() => _FavoritePlayersScreenState();
}

class _FavoritePlayersScreenState extends State<FavoritePlayersScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'update');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Moji obľúbení hráčí'),
          
        ),
        body: FutureBuilder<List<UserDetails>>(
          future: _getFavoritePlayers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Chyba pri načítaní'),
              );
            } else {
              final favoritePlayers = snapshot.data;
              if (favoritePlayers != null && favoritePlayers.isNotEmpty) {
                return UserList(users: favoritePlayers);
              } else {
                return const Center(
                  child:  Text('Ešte nemáš žiadnych obľúbených hráčov'),
                );
              }
            }
          },
        ),
      ),
    );
  }

Future<List<UserDetails>> _getFavoritePlayers() async {
    API api = API();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePlayerIds = prefs.getStringList('favoritePlayerIds') ?? [];
    List<UserDetails> favoritePlayers = [];

    for (String playerId in favoritePlayerIds) {
      final user = await api.getUserDetails(int.parse(playerId));
      favoritePlayers.add(
        user
      );
    }

    return favoritePlayers;
  }
  
}
class UserList extends StatelessWidget {
  final List<UserDetails> users;

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
  final UserDetails user;

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

