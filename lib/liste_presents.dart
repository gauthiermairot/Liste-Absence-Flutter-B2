import 'package:flutter/material.dart';
import 'eleves.dart';
import 'liste_appel.dart';

bool isLoaded = false;
List<Eleves> eleves = [];
String nbAbsentsString = '0';
String nbRetardsString = '0';

var elevesAbsents = List<Eleves>();

class ListeAbsents extends StatelessWidget {

  String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Elèves absents'),
        titleSpacing: 10.0,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => Home())
              );
            }
        ),
        centerTitle: false,
        elevation: 20.0,
        backgroundColor: Colors.teal,
      ),
      body: new Center(
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot eleves){
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: elevesAbsents.length,
                itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            elevesAbsents[index].image
                        ),
                      ),
                      title: Text(elevesAbsents[index].nom),
                      onTap: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => PageEtudiant(elevesAbsents[index]))
                        );
                      },
                    );
                },
              );
          },
        ),
      ),
    );
  }
}