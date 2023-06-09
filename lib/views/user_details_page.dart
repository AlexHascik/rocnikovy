import 'package:flutter/material.dart';
import 'package:flutter_rocnikovy/apis/api.dart';
import 'package:flutter_rocnikovy/data/Registration.dart';
import 'package:flutter_rocnikovy/data/user_details.dart';


class UserDetailsPage extends StatelessWidget{
  final int id;
  late final Future<UserDetails> userDetails;
  final API _api= API();
  UserDetailsPage({super.key, required this.id});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(  
        title: const Text('Osobné údaje'),
        
      ),
      body: FutureBuilder<UserDetails>(
        future: _api.getUserDetails(id),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            UserDetails userDetails = snapshot.data!;
            return Details(userDetails: userDetails);
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator()
             );
          }
        }

      )
    );
  }
}

class Details extends StatelessWidget {
  final UserDetails userDetails;
  const Details({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    String firstName = userDetails.firstName!;
    String lastName = userDetails.lastName!;
    String fullName = "$firstName $lastName";
    String registrationId = "";
    

    Registration? getHosting(){
      for (Registration registration in userDetails.registrations!) {
        if(registration.status == 'active' && registration.type == 'hosting'){
          return registration;
        }  
      }
      return null;
    }

    return SingleChildScrollView(
          
          child: Padding(
            padding: const EdgeInsets.only(left: 35.0, top: 20.0, right: 35.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0), // for spacing
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(userDetails.photo!),
                ),
                const SizedBox(height: 15.0), // for spacing
                Text(
                  userDetails.institutionRegistrationId == null ? registrationId : '#${userDetails.institutionRegistrationId}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 102, 100, 100),
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  fullName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 31.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 const SizedBox(height: 10.0),
                Text(
                  userDetails.institutionSportName!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  height: 40.0,
                  thickness: 2.0,
                  
                ),
                 Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildInfoRow('Dátum narodenia', userDetails.birthday == null ? '' : transformDate(userDetails.birthday!)),
                    buildInfoRow('Členský príspevok', userDetails.feeValid == null ? '' : transformDate(userDetails.feeValid!)),
                    buildInfoRow('Platnosť registrácie', userDetails.institutionExpired == null ? '' : transformDate(userDetails.institutionExpired!)),
                    buildInfoRow('NBC ID', userDetails.nbcId == null ? '' : userDetails.nbcId!),
                  ],
                ),
              ),
                 getHosting() == null ? const Text('') : hosting(getHosting()!)

            ],
        ),
          ),
      );
  }

  Column hosting(Registration host){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  <Widget>[
        const Text(
        'Hosťovanie',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
        '#${host.registrationId}',
          style: const TextStyle(
            color: Color.fromARGB(255, 102, 100, 100),
            fontSize: 22.0,
            fontWeight: FontWeight.normal,
          ),
        ),
          ],
        ),
        const Divider(
        color: Colors.black,
        height: 10.0,
        thickness: 2.0,                
        ),
         Text(
          host.institution!.sportName!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
         transformDate(host.to!),
          style: const TextStyle(
            color: Color.fromARGB(255, 102, 100, 100),
            fontSize: 19.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Padding buildInfoRow(String header, String definition) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: <Widget>[
          Text(
            header,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0), // for spacing
          Text(
            definition,
            style: const TextStyle(
              color: Color.fromARGB(255, 102, 100, 100),
              fontSize: 19.0,
            ),
          ),
        ],
      ),
    );
  }

  String transformDate(String date){
    DateTime dateTime = DateTime.parse(date);
    String output = "${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year}";
    return output;
  }
}

class ProfilePicture extends StatelessWidget{
  final UserDetails userDetails;
  const ProfilePicture({super.key, required this.userDetails});

  @override 
  Widget build(BuildContext context){
      return Align(
        alignment: Alignment.center,
        child: Visibility(
                        visible: userDetails.photo != '',
                        child: GestureDetector(
                          onTap: (){
                            showDialog(  
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(  
                                  content: Image.network(userDetails.photo!),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: (() => Navigator.of(context).pop()
                                    ),
                                      child: const Icon(Icons.cancel, color: Colors.black)
                                    ),
                                    
                                  ],
                                );
                              }
                            );
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(userDetails.photo!)
                          ),
                        )
      
                      ),
        
      );
  }
}

class _RegistrationInfo extends StatelessWidget{
  final Registration registration;
  const _RegistrationInfo({required this.registration});

  @override 
  Widget build(BuildContext context){
    return ExpansionTile(title: 
      Text(registration.institution!.name!,
        style: const TextStyle(  
          fontSize: 15
        )
      ),
      children:[
        
        DetailsText(head: 'Id: ', value: registration.id!),
        DetailsText(head: 'Od: ', value: registration.from!),
        DetailsText(head: 'Do: ', value: registration.to!),
        DetailsText(head: 'Status: ', value: registration.status!),
        DetailsText(head: 'Typ: ', value: registration.type!)

      ]
      );
  }
}

class DetailsText extends StatelessWidget{
  final String head;
  final String value;
  const DetailsText({super.key, required this.head, required this.value});

  @override  
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
              TextSpan(text: head, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              TextSpan(text: value, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.normal)),
          ],
          ),
      ),
      ),
    );
  }
}

class TextWithPadding extends StatelessWidget{
  final String text;
  const TextWithPadding({super.key, required this.text});



  @override 
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Text(text,
        style: const TextStyle(  
          fontWeight: FontWeight.bold,
          fontSize: 17
        )
      ),
    );
  }
  
  
}

