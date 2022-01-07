import 'package:eflashcard/flashcard.dart';
import 'package:eflashcard/language.dart';
import 'package:eflashcard/writing_systems_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'flashcard_view.dart';

void main() async {
  /*
   * Magic firebase code from https://stackoverflow.com/a/63537567 and https://stackoverflow.com/a/70234018
   * Thank the heavens for blessing me with stackoverflow
   */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eflashcard',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currIndex = 0;


  static const japanese = Language(
      name: 'Japanese',
      writingSystems: {
        'hr':"Hiragana",
        'kj':'Kanji',
        'en':'English'});
  final List<Language> _languages = [japanese];

  List<Flashcard> _flashcards = [
    const Flashcard(kj: '日本語', hr: 'にほんご', en: 'japanese')
  ];
  late FlashcardView flashcardView;
  late String _frontWS;
  late String _backWS;


  @override
  Widget build(BuildContext context) {

    WritingSystemsDropdown _wsDropdown = WritingSystemsDropdown(
        writingSystems: japanese.writingSystems,
        notifyParent: updateFlashcardsFromDropdown,
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _wsDropdown,
            StreamBuilder(
            stream: FirebaseFirestore.instance.collection('flashcards')
            .snapshots(),  // query firestore for flashcards documents
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.error);
                }
                return const Text('Error encountered. Please restart app.');
              } else {
                // I believe in api documentation https://firebase.google.com/docs/reference/js/v8/firebase.firestore.QuerySnapshot#docs
                QuerySnapshot<Object?> _qs = snapshot.data as QuerySnapshot; //
                // casting
                if (_qs.size == 0) return const Text('No flashcards');  //
                // flashcards document not found
                List<QueryDocumentSnapshot<Object?>> _qds = _qs.docs;
                _flashcards = [];
                _qds.forEach((doc) {
                    // Godsend https://stackoverflow.com/a/60246487
                    // https://stackoverflow.com/a/63529675
                    var _data = doc.data() as Map;
                    _flashcards.add(Flashcard(
                      en: _data["en"],
                      hr: _data["hr"],
                      kj: _data["kj"]));
                  }
                );
                _currIndex = (_currIndex > _flashcards.length - 1 ||
                    _currIndex <
                    0) ? 0 : _currIndex;

                return flashcardView = FlashcardView(
                    front: _flashcards[_currIndex].get(_frontWS),
                    back: _flashcards[_currIndex].get(_backWS),
                  );
              }
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: showPrevCard,
                  icon: Icon(Icons.chevron_left),
                  label: Text('Prev')),
                OutlinedButton.icon(
                    onPressed: showNextCard,
                    icon: Icon(Icons.chevron_right),
                    label: Text('Next'))
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add Flashcard',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showPrevCard() {
    setState(() {
      _currIndex = (_currIndex - 1 >= 0) ? _currIndex - 1
          : _flashcards.length - 1;
      flashcardView.resetFlip();
    });
  }

  void showNextCard() {
     setState(() {
       _currIndex = (_currIndex + 1 < _flashcards.length) ? _currIndex + 1 : 0;
       flashcardView.resetFlip();
     });
  }

  // Observer Pattern https://stackoverflow.com/a/51778268
  void updateFlashcardsFromDropdown(String frontValue, String backValue) {
    _frontWS = frontValue;
    _backWS = backValue;
  }

}
