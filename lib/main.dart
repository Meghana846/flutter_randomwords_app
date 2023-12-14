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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea( //first widget
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded( //second widget, Expanded widgets are extremely useful in rows and columns
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var generatedWord = appState.current;
    IconData icon;
    if (appState.favorites.contains(generatedWord)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(generatedWord: generatedWord),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var generatedWord in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(generatedWord.asLowerCase),
          ),
      ],
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















