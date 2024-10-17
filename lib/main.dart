import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_flutter_package/test_flutter_package.dart';

void main() {
  runApp(MyApp());
}

class Data {
  static const List<String> topList = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
  ];

  static const List<List<String>> topListMap = [
    ['one', 'two', 'three'],
    ['2four', '2five', '2six'],
    ['3one', '3two', '3three'],
    ['4four', '4five', '4six'],
    ['5one', '5two', '5three'],
    ['6four', '6five', '6six'],
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final firstList = Data.topList;

  var index = 0;

  void receiveAction(BuildContext context, BlueListAction action) {
    switch (action) {
      case RowTap(index: var index):
        context.read<YellowWidgetState>().setListNames(index);
    }
  }
}

// ...

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Text("text");
    return Scaffold(
        body: Row(
      children: [
        Text("Hello"),
        SizedBox(width: 10),
        Expanded(
          child: BlueList(),
        ),
        Expanded(
          child: YellowListParent(),
        )
      ],
    ));
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
          context.read<MyAppState>().receiveAction(context, RowTap(index));
        },
      );
    },
  );
}

class YellowWidgetState extends ChangeNotifier {
  var secondaryList = Data.topListMap[0];

  void setListNames(int index) {
    secondaryList = Data.topListMap[index];
    notifyListeners();
  }
}

Widget YellowListParent() {
  return ChangeNotifierProvider(
      create: (context) => YellowWidgetState(), child: YellowList());
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

sealed class BlueListAction {}

class RowTap extends BlueListAction {
  final int index;
  RowTap(this.index);
}
