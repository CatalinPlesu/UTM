import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: const MyHomePage(title: 'Age Calculator (lab_2)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "Your age isn't determined";
  DateTime setDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text( message,
            style:
              TextStyle(
                fontSize: 20,
              ),),
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: pickBirthDate,
      //  tooltip: 'Pick Date',
      //  child: const Icon(Icons.calendar_month_rounded),
      //), // This trailing comma makes auto-formatting nicer for build methods.

        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Icon(
                    Icons.refresh
                ),
                onPressed: () {
                  setState(() {
                    message = "Introduceti varsta";
                    setDate = DateTime.now();
                  });
                  //...
                },
                heroTag: null,
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                child: Icon(
                    Icons.calendar_month_rounded
                ),
                onPressed: () => pickBirthDate(),
                heroTag: null,
              )
            ]
        )

    );
  }
  Future pickBirthDate() async {
    DateTime? date = await showDatePicker(context: context, initialDate: setDate, firstDate: DateTime(1900), lastDate: DateTime.now());
    if(date != null){
      setDate = date;
    }
    int d = date!.day;
    int m = date!.month;
    int y = date!.year;

    DateTime curentDate = DateTime.now();
    int cd = curentDate.day;
    int cm = curentDate.month;
    int cy = curentDate.year;

    if(d<=cd){
      d = cd - d;
    }else{
      d = cd - d + 31;
      cm -= 1;
    };
    if(m<=cm){
      m = cm - m;
    }else{
      m = cm - m + 12;
      cy -= 1;
    };
    y = cy - y;

    setState(() {
      message = "You are ${y} years ${m} months ${d} days old";
    });
  }
}
