import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'main.dart';
import 'eleves.dart';
import 'liste_presents.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return new _Home();
  }
}


Future<List<Eleves>> _getUsers() async {
  if (isLoaded == false) {
    var data = await http.get("http://www.json-generator.com/api/json/get/bTwkchSMQy?indent=2");
    var jsonData = json.decode(data.body);
    for(var i in jsonData){
      Eleves eleve = Eleves(i["nom"], i["email"], i["image"], false, false);
      eleves.add(eleve);
    }
    isLoaded = true;
  }
  return eleves;
}

class _Home extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: new AppBar(
        title: new Text('EPSI B2G1'),
        titleSpacing: 10.0,
        leading: new Image.asset('img/epsi.jpg'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.list),
              onPressed: (){
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => ListeAbsents())
                );
              }
          )
        ],
        centerTitle: false,
        elevation: 20.0,
        backgroundColor: Colors.teal,
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            Text('Absents : ' + nbAbsentsString),
            Text('Retards : ' + nbRetardsString),
            Flexible(
              child: FutureBuilder(
                future: _getUsers(),
                builder: (BuildContext context, AsyncSnapshot eleve){
                  if(eleve.data == null){
                    return Container(
                        child: Center(
                            child: Text("Loading...")
                        )
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10.0),
                      itemCount: eleve.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                eleve.data[index].image
                            ),
                          ),
                          title: Text(eleve.data[index].nom),
                          subtitle: Text(eleve.data[index].email),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new IconButton(
                                  icon: Icon(eleve.data[index].absent ? Icons.block : Icons.account_circle,
                                      color: eleve.data[index].absent ? Colors.red : Colors.green),
                                  onPressed: () {
                                    setState(() {
                                      if(eleve.data[index].absent == false && eleve.data[index].retard == true) {
                                        snackBar(context);
                                      }
                                      else if(eleve.data[index].absent == true) {
                                        eleve.data[index].absent = false;
                                        int nbAbsents = int.parse(nbAbsentsString);
                                        nbAbsents --;
                                        elevesAbsents.remove(eleve.data[index]);
                                        nbAbsentsString = nbAbsents.toString();
                                      }
                                      else {
                                        eleve.data[index].absent = true;
                                        int nbAbsents = int.parse(nbAbsentsString);
                                        nbAbsents ++;
                                        elevesAbsents.add(eleve.data[index]);
                                        nbAbsentsString = nbAbsents.toString();
                                      }
                                    });
                                  },
                                ),
                                new IconButton(
                                  icon: Icon(
                                      Icons.access_time,
                                      color: eleve.data[index].retard ? Colors.red : Colors.green
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if(eleve.data[index].retard == false && eleve.data[index].absent == true) {
                                        snackBar(context);
                                      }
                                      else if(eleve.data[index].retard == true){
                                        eleve.data[index].retard = false;
                                        int nbRetards = int.parse(nbRetardsString);
                                        nbRetards --;
                                        nbRetardsString = nbRetards.toString();
                                      }
                                      else {
                                        eleve.data[index].retard = true;
                                        int nbRetards = int.parse(nbRetardsString);
                                        nbRetards ++;
                                        nbRetardsString = nbRetards.toString();
                                      }
                                    });
                                  },
                                ),
                              ]),
                          onTap: (){
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) => PageEtudiant(eleve.data[index]))
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),


      ),
    );

  }

  snackBar(BuildContext context) {
    SnackBar snackBar = new SnackBar(
      content: Text('Un élève ne peut pas être absent et en retard'),
      duration: new Duration(seconds: 2),
      backgroundColor: Colors.teal,
    );
    var showSnackBar = Scaffold.of(context).showSnackBar((snackBar));
  }
}


class PageEtudiant extends StatelessWidget {

  final Eleves user;

  PageEtudiant(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.nom),
          backgroundColor: Colors.teal,
        )
    );
  }
}