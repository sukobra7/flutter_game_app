import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  bool turnOfCircle = true;
  List<PieceStatus> statusList = List.filled(9, PieceStatus.none);
  GameStatus gameStatus = GameStatus.play;
  List<Widget> buildLine = [Container()];
  double lineThickness = 6.0;
  double lineWidth;


  final List<List<int>> settlementListHorizontal = [
    [0,1,2],
    [3,4,5],
    [6,7,8]
  ];

  final List<List<int>> settlementListVertical = [
    [0,3,6],
    [1,4,7],
    [2,5,8]
  ];

  final List<List<int>> settlementListDiagonal = [
    [0,4,8],
    [2,4,6]
  ];

  @override
  Widget build(BuildContext context) {
    lineWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.circle, color: Colors.green),
            Icon(Icons.clear, color: Colors.red),
            Text('ゲーム')
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(),
                OutlineButton(
                  borderSide: BorderSide(),
                  child: Text('クリア'),
                  onPressed: () {
                    setState(() {
                      turnOfCircle = true;
                      statusList = List.filled(9, PieceStatus.none);
                      gameStatus = GameStatus.play;
                      buildLine = [Container()];
                    });
                },
                )
              ],
            ),
          ),
          buildField(),
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget buildText() {
    switch(gameStatus) {
      case GameStatus.play:
        return Row(
          children: [
            turnOfCircle ? Icon(FontAwesomeIcons.circle) : Icon(Icons.clear),
            Text('のターンです'),
          ],
        );
        break;
      case GameStatus.draw:
        return Text('引き分けです');
        break;
      case GameStatus.settlement:
        return Row(
          children: [
            !turnOfCircle ? Icon(FontAwesomeIcons.circle) : Icon(Icons.clear),
            Text('の勝ちです'),
          ],
        );
      default:
        return Container();
    }
  }

  Stack buildField() {
    List<Widget> _columnChildren = [Divider(height: 0.0, color: Colors.black)];
    List<Widget> _rowChildren = [];

    for (int j = 0; j < 3; j++) {
      for (int i = 0; i < 3; i++) {
        int _index = j * 3 + i;
        _rowChildren.add(
          Expanded(
            child: InkWell(
              onTap: gameStatus == GameStatus.play ? () {
                if (statusList[_index] == PieceStatus.none) {
                  statusList[_index] =
                  turnOfCircle ? PieceStatus.circle : PieceStatus.cross;
                  turnOfCircle = !turnOfCircle;
                  confirmResult();
                }
                setState(() {
                });
              } : null,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Row(
                  children: [
                    Expanded(
                      child: buildContainer(statusList[_index])
                    ),
                    (i == 2) ? Container() : VerticalDivider(width: 0.0, color: Colors.black),
                  ],
                )
              ),
            )
          ),
        );
      }
      _columnChildren.add(Row(children: _rowChildren,));
      _columnChildren.add(Divider(height: 0.0, color: Colors.black));
      _rowChildren = [];
    }

    return Stack(
      children: [
        Column(children: _columnChildren),
        Stack(
          children: buildLine,
        )
      ],
    );
  }

  Container buildContainer(pieceStatus) {
    switch(pieceStatus) {
      case PieceStatus.none:
        return Container();
        break;
      case PieceStatus.circle:
        return Container(
          child: Icon(FontAwesomeIcons.circle, size: 60, color: Colors.blue),
        );
        break;
      case PieceStatus.cross:
        return Container(
          child: Icon(Icons.clear, size: 60, color: Colors.red),
        );
        break;
      default:
        return Container();
    }
  }

  void confirmResult() {
    if(!statusList.contains(PieceStatus.none)) {
      gameStatus = GameStatus.draw;
      }
    for(int i = 0; i < settlementListHorizontal.length; i++) {
      if (statusList[settlementListHorizontal[i][0]] == statusList[settlementListHorizontal[i][1]] && statusList[settlementListHorizontal[i][0]] == statusList[settlementListHorizontal[i][2]] && statusList[settlementListHorizontal[i][0]]!= PieceStatus.none) {
        buildLine.add(
          Container(
            width: lineWidth,
            height: lineThickness,
            color: Colors.black.withOpacity(0.3),
            margin: EdgeInsets.only(top: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
            )
        );
        gameStatus = GameStatus.settlement;
      }
    }
    for(int i = 0; i < settlementListVertical.length; i++) {
      if (statusList[settlementListVertical[i][0]] == statusList[settlementListVertical[i][1]] && statusList[settlementListVertical[i][0]] == statusList[settlementListVertical[i][2]] && statusList[settlementListVertical[i][0]]!= PieceStatus.none) {
        buildLine.add(
          Container(
            width: lineThickness,
            height: lineWidth,
            color: Colors.black.withOpacity(0.3),
            margin: EdgeInsets.only(left: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
          )
        );
        gameStatus = GameStatus.settlement;
      }
    }
    for(int i = 0; i < settlementListDiagonal.length; i++) {
      if (statusList[settlementListDiagonal[i][0]] == statusList[settlementListDiagonal[i][1]] && statusList[settlementListDiagonal[i][0]] == statusList[settlementListDiagonal[i][2]] && statusList[settlementListDiagonal[i][0]]!= PieceStatus.none) {
        buildLine.add(
          Transform.rotate(
            alignment: i == 0 ? Alignment.topLeft : Alignment.topRight,
            angle: i == 0 ? -pi / 4 : pi / 4,
            child: Container(
              width: lineThickness,
              height: lineWidth * sqrt(2),
              color: Colors.black.withOpacity(0.3),
              margin: EdgeInsets.only(left: i == 0 ? 0.0 : lineWidth - lineThickness)
            ),
          )
        );
        gameStatus = GameStatus.settlement;
      }
    }

  }
}