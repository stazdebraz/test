import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_app/core/assets/app_images.dart';

class AppGame extends StatefulWidget {
  const AppGame({super.key});

  @override
  State<AppGame> createState() => _AppGameState();
}

class _AppGameState extends State<AppGame> {
  int currentZone = 1;
  double keeperLeft = 0;
  double keeperRight = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penalty')),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
          color: Colors.green,
        ),
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 70,
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: currentZone == index
                                  ? Colors.white
                                  : Colors.blue),
                          onPressed: () {
                            currentZone = index;
                            setState(() {});
                          },
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                fontSize: 20,
                                color: currentZone == index
                                    ? Colors.black
                                    : Colors.white),
                          ));
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 10, color: Colors.white),
                        left: BorderSide(width: 10, color: Colors.white),
                        top: BorderSide(width: 10, color: Colors.white))),
              ),
            ),
          ],
        ),
        Positioned(
          left: keeperLeft,
          right: keeperRight,
          top: 70,
          child:
              SizedBox(height: 180, child: Image.asset(AppImages.goalKeeper)),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 100,
          child: SizedBox(height: 50, child: Image.asset(AppImages.ball)),
        ),
        Positioned(
            left: 10,
            bottom: 20,
            child: SizedBox(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  onPressed: () {
                    final int random = Random().nextInt(3) - 0;
                    print(random);
                    switch (random) {
                      case 2:
                        keeperRight = -50;
                        keeperLeft = 200;
                        break;
                      case 1:
                        keeperLeft = 0;
                        keeperRight = 0;
                        break;
                      case 0:
                        keeperRight = 200;
                        keeperLeft = -50;
                        break;
                      default:
                    }
                    if (currentZone != random) {
                      Fluttertoast.showToast(
                          msg: "GOAL!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "The goalkeeper caught the ball",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('KICK'),
                  )),
            ))
      ]),
    );
  }
}
