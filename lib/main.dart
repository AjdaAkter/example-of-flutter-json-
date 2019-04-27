import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Recipe>> _getUsers() async {
    // basic authenticition
    var data = await http.get("http://kerimcaglar.com/yemek-tarifi");
    //debugPrint(data);
    var jsonData = json.decode(data.body);
    List<Recipe> users = [];
    for (var u in jsonData) {
      Recipe user = Recipe(
          u["id"],
          u["yemek_ismi"],
          u["yemek_mutfak"],
          u["sure"],
          u["kisi_sayisi"],
          u["malzemeler"],
          u["tarif"],
          u["yemek_resim"]);
      users.add(user);
    }
    print(users.length);
    debugPrint(data.body);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Json Example",
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.purpleAccent,
          title: new Text(
            "Yemek Tarifleri",
            style: new TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                decorationColor: Colors.black),
          ),
        ),
        body: Container(
            child: new FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                padding: EdgeInsets.all(18),
                child: new Center(
                  child: new Text("Loading..."),
                ),
              );
            } else {
              return ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: 7,
                separatorBuilder: (BuildContext context, int index) => Divider(
                      color: Colors.black,
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: new CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].yemek_resim),
                    ),
                    title: Text(
                      (snapshot.data[index].yemek_ismi).toString(),
                      style: new TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                        (snapshot.data[index].kisi_sayisi).toString() +
                            " kişilik"),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        )),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Recipe user;

  const DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.purpleAccent,
        title: new Text(user.yemek_ismi),
      ),
      body: new Container(
          child: new Column(
        children: <Widget>[
          new Container(
            height: 200,
            width: 900,
            child: Image.network(
              //Jsona yeni veri eklenir ve oradan çagırılabilir....
              'http://komek.org.tr/images/menufoto/ty475159.jpg',
            ),
          ),
          new Expanded(
            child: new Container(
              padding: EdgeInsets.all(15),
              child: new Text(
                user.tarif,
                textScaleFactor: 1.5,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class Recipe {
  final int id;
  final String yemek_ismi;
  final String yemek_mutfak;
  final String sure;
  final String kisi_sayisi;
  final String malzemeler;
  final String tarif;
  final String yemek_resim;

  Recipe(this.id, this.yemek_ismi, this.yemek_mutfak, this.sure,
      this.kisi_sayisi, this.malzemeler, this.tarif, this.yemek_resim);
}
