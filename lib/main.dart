import 'package:flutter/material.dart';
import 'package:se/mapspage.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'balu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[500],
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Divyadeepa BTracker'),
              ]),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                constraints: BoxConstraints.expand(height: 300),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/first.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(
                      child: new RaisedButton(
                          color: Colors.blue[500],
                          onPressed: () => print("Button Pressed"),
                          splashColor: Colors.blueGrey,
                          child: new Text("Volunteer"),
                          padding: EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black),
                          )),
                    ),
                    new Container(
                      child: new RaisedButton(
                          color: Colors.blue[500],
                          onPressed: () {
                            _showDialog();
                          },
                          splashColor: Colors.blueGrey,
                          child: new Text("Van"),
                          padding: EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black),
                          )),
                    ),
                  ]),
            ],
          ),
        ));
  }

  _showDialog() async {
    String test = '4949';
    TextEditingController _firsttb = new TextEditingController();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: _firsttb,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'PIN', hintText: 'Driver pin'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Submit'),
              onPressed: () {
                if (_firsttb.text == test) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MapsPage()));
                  // Navigator.pop(context);

                } else {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Wrong pin",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.black,
                      fontSize: 16.0);
                }
              }),
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
