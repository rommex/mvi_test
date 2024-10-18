import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Data {
  static const List<String> topList = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
  ];

  static const List<List<String>> secondaryList = [
    ['1one', '2two', '3three'],
    ['2four', '2five', '2six'],
    ['3one', '3two', '3three'],
    ['4four', '4five', '4six'],
    ['5one', '5two', '5three'],
    ['6four', '6five', '6six'],
  ];
}

//=========================================================

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This widget is a parent for both BlueList and YellowListParent
    // and is the proper place for the prividers of the two states.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => YellowWidgetState()),
        ChangeNotifierProvider(create: (context) => BlueListState()),
      ],
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: BlueList(),
            ),
            SizedBox(width: 10),
            Expanded(
              child: YellowList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Children Widgets and their states

class BlueListState extends ChangeNotifier {
  var index = 0;

// The state has only one entry point for actions
  void triggerAction(BuildContext context, BlueListAction action) {
    if (action is RowTap) {
      index = action.index;
      // find the state of the YellowWidgetState via the context
      final yellowState = context.read<YellowWidgetState>();

      // modify the state of the YellowWidgetState
      yellowState.setListNames(index);
    }
  }
}

ListView BlueList() {
  return ListView.builder(
    itemCount: Data.topList.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(Data.topList[index]),
        tileColor: Colors.blue,
        onTap: () {
          context.read<BlueListState>().triggerAction(context, RowTap(index));
        },
      );
    },
  );
}

//---

class YellowWidgetState extends ChangeNotifier {
  var secondaryList = Data.secondaryList[0];

  void setListNames(int index) {
    secondaryList = prepareDisplayData(index);
    notifyListeners();
  }

  List<String> prepareDisplayData(int index) {
    return Data.secondaryList[index];
  }
}

ListView YellowList() {
  return ListView.builder(
    itemCount: 3,
    itemBuilder: (context, index) {
      var appState = context.watch<YellowWidgetState>();
      final _list = appState.secondaryList;

      return ListTile(
        title: Text(_list[index]),
        tileColor: Colors.yellow,
      );
    },
  );
}

//====Actions================================================

abstract class BlueListAction {}

class RowTap extends BlueListAction {
  final int index;
  RowTap(this.index);
}
