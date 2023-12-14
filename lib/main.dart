import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp()); //run the app defined in MyApp
}

class MyApp extends StatelessWidget { //widgets are the elements from which you build every flutter app
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { //every widget has a build method, which tells what the app contains
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //Myappstate class defines the app's state.
  var current = WordPair.random();

  void getNext(){ //The new getNext() method reassigns current with a new random WordPair.
    current = WordPair.random();
    notifyListeners(); //calls notifyListeners(), a method of ChangeNotifier
  }
  var favorites = <WordPair>[];
  void toggleFavorite(){
    if(favorites.contains(current)){
      favorites.remove(current);
    }else{
      favorites.add(current);
    }
    notifyListeners();
  }
} //to manage app state we are using changenotifier(this is just an example)

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //Every build method must return a widget or nested tree of widgets
    var appState = context.watch<MyAppState>(); // tracks changes to the app's current state using the watch method
    var generatedWord = appState.current;

    IconData icon;
    if(appState.favorites.contains(generatedWord)){
      icon = Icons.favorite;
    }else{
      icon = Icons.favorite_border;
    }

      return Scaffold(
      body: Center(
        child: Column( //Column is one of the most basic layout widgets t takes any number of children and puts them in a column from top to bottom
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text('A randomly generated word:'),
            BigCard(generatedWord: generatedWord),
            SizedBox(height: 20),
            Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  ElevatedButton.icon(
                    onPressed: (){
                      appState.toggleFavorite();
                  },
                    icon: Icon(icon),
                    label: Text('Like'),
                ),
                  ElevatedButton(
                  onPressed: () {
                  appState.getNext();
                  },
                  child: Text('Next'),
                  ),
                    //SizedBox(width: 30,)
               ],
              ),
            ],
          ),
        )
      );
    }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key, // Add the key argument here
    required this.generatedWord,
  }) : super(key: key); // Move const before super.key


  final WordPair generatedWord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!
        .copyWith( //theme.textTheme, is used to access the apps font theme
      color: theme.colorScheme.onPrimary,
    );
    //body medium for standard text of medium size
    return Card(
      color: theme.colorScheme.secondary, //cards color
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(generatedWord.asLowerCase,
          style: style,
          semanticsLabel: "${generatedWord.first} ${generatedWord.second}",
        ),
      ),
    );

}
}















