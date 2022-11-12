import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];

  static var randomNumber = Random();
  int food = randomNumber.nextInt(250);
  var direction = 'down';
  bool showNav = false;
  void startGame(int numberOfSquares) {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      setState(() {
        showNav = true;
        food = SnakeMovingUpdate(numberOfSquares, snakePosition, food, direction);
      });

      if (gameOver(snakePosition)) {
        timer.cancel();
        setState(() {
          showNav = false;
        });
        _showGameOverScreen(numberOfSquares);
      }
    });
  }

  void _showGameOverScreen(int numberOfSquares) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Color.fromRGBO(48, 71, 94, 1),
            content: Text(
              'You scored ' + snakePosition.length.toString(),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    showNav=false;
                    startGame(numberOfSquares);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final int numberOfSquares = 760;
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 40, 49, 1),
      body: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy < -250) {
              if (direction != 'down') {
                direction = 'up';
              }
            } else if (details.velocity.pixelsPerSecond.dy > 250) {
              if (direction != 'up') {
                direction = 'down';
              }
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx < -1000) {
              if (direction != 'right') {
                direction = 'left';
              }
            } else if (details.velocity.pixelsPerSecond.dx > 1000) {
              if (direction != 'left') {
                direction = 'right';
              }
            }
          },
          child:  Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: numberOfSquares,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 20),
                          itemBuilder: (BuildContext context, int index) {
                            if (snakePosition.contains(index)) {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (index == food) {
                              return Container(
                                padding: EdgeInsets.all(0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(color: Colors.green)),
                              );
                            } else {
                              return Container(
                                padding: EdgeInsets.all(0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Container(
                                        color: Color.fromRGBO(48, 71, 94, 0.3))),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
              !showNav
                  ? Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.3)),
                    ),
                    onPressed: () {
                      startGame(numberOfSquares);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Center(
                        child: Text(
                          'START',
                          style: TextStyle(
                              color: Color.fromRGBO(221, 221, 221, 1),
                              fontSize: 30),
                        ),
                      ),
                    )),
              ):Container(height: 0,width: 0,)
            ],
          ),
      ),




    );
  }

  int SnakeMovingUpdate(int numberOfSquares, List<int> snakePosition, int food,
      String direction) {
    switch (direction) {
      case 'down':
        if (snakePosition.last > (numberOfSquares - 20)) {
          snakePosition.add(snakePosition.last + 20 - numberOfSquares);
        } else {
          snakePosition.add(snakePosition.last + 20);
        }

        break;

      case 'up':
        if (snakePosition.last < 20) {
          snakePosition.add(snakePosition.last - 20 + numberOfSquares);
        } else {
          snakePosition.add(snakePosition.last - 20);
        }
        break;

      case 'left':
        if (snakePosition.last % 20 == 0) {
          snakePosition.add(snakePosition.last - 1 + 20);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }

        break;

      case 'right':
        if ((snakePosition.last + 1) % 20 == 0) {
          snakePosition.add(snakePosition.last + 1 - 20);
        } else {
          snakePosition.add(snakePosition.last + 1);
        }
        break;

      default:
    }

    if (snakePosition.last == food) {
      food = Random().nextInt(numberOfSquares);
      return food;
    } else {
      snakePosition.removeAt(0);
    }

    return food;
  }

  bool gameOver(List<int> snakePosition) {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }
}
