import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {

  Text title = const Text('E-Služby SKoZ');
  Text playersTitle = const Text('Hráči');
  Text playersList = const Text('Zoznam hráčov');
  Text clubsTitle = const Text('Kluby');
  Text clubsList = const Text('Zoznam klubov');

  HomePage({super.key});

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(  
        title: title,
        centerTitle: true,
      ),
      body: ListView(
        children:  <Widget>[
          ListTile(title: playersTitle, 
            subtitle: playersList, 
            trailing: const Icon(Icons.navigate_next),
            shape: const Border(bottom: BorderSide()),
            onTap: (){
            }
          ),
          ListTile(title: clubsTitle,
           subtitle: clubsList, 
           trailing:const Icon(Icons.navigate_next),
           shape: const Border(bottom: BorderSide()),
           onTap: (){
               
            }

          ),
        ],
      ),
    );
  }
}