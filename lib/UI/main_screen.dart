import 'dart:math';

import 'package:commute/UI/profile_screen.dart';
import 'package:commute/UI/register_screen.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:commute/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final _controller = AController.to;
  AnimationController _animationController;
  final MethodChannel channel = MethodChannel('com.example.commute/wifi');
  Color _color;
  Future result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _color = (_controller.user.isCommuted) ? Colors.blue[800] : Colors.red;
    if (_controller.user.isCommuted) _controller.startTimer();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    result = channel.invokeMethod('getMacAddress');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: Get.height - MediaQuery.of(context).padding.top,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            AnimatedPositioned(
                top: (_controller.user.isCommuted) ? 0 : -Get.height,
                duration: Duration(milliseconds: 1200),
                curve: Curves.bounceOut,
                onEnd: () {
                  //TODO : startTimeDiffTimer
                  _controller.startTimer();
                },
                child: Stack(overflow: Overflow.visible, children: [
                  CustomPaint(
                    size: Get.size,
                    painter: CurvePainter(),
                  ),
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.17),
                      child: Text(
                        "출근 완료",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.25),
                        child: SizedBox(
                          width: Get.width * 0.5,
                          height: Get.height * 0.16,
                          child: Card(
                            elevation: 10,
                            child: Center(
                              child: GetBuilder<AController>(
                                builder: (_) => Text(_.calculateTimeDiff()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.23),
                      child: Card(
                        shape: CircleBorder(),
                        elevation: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check),
                        ),
                      ),
                    ),
                  )),
                ])),

            // Center(
            //   child: IconButton(
            //     iconSize: 50,
            //       icon: AnimatedIcon(color:Colors.blue,icon: AnimatedIcons.menu_home, progress: _animationController),
            //     splashColor: Colors.blueAccent,
            //     onPressed: () async {
            //       _controller.user.isCommuted = !_controller.user.isCommuted;
            //       await _controller.updateUserData();
            //       setState(() {
            //         (_controller.user.isCommuted) ? _animationController.forward() : _animationController.reverse();
            //
            //       });
            //     },
            //   ),
            // ),
            Center(
              child: ToggleButtons(
                isSelected: _controller.toggleList,
                children: <Widget>[
                  Icon(Icons.home),
                  Icon(Icons.work_outline_rounded)
                ],
                onPressed: (int index) async {

                  if(!_controller.toggleList[index]){


                    await _controller.updateUserData();

                    _controller.user.isCommuted = !_controller.user.isCommuted;

                    setState(() {
                      _controller.toggleList = _controller.toggleList.reversed.toList();
                    });

                  }
                },
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.095,
                minChildSize: 0.085,
                maxChildSize: 0.4,
                builder: (context, controller) => Stack(
                      overflow: Overflow.clip,
                      children: [
                        SingleChildScrollView(
                          controller: controller,
                          child: Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24)),
                                  child: buildContent())),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: Get.height * 0.4),
                              child: OverflowBox(
                                maxHeight: 200,
                                maxWidth: 200,
                                child: Card(
                                  shape: CircleBorder(),
                                  elevation: 10,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
          ],
        ),
      ),
    ));
  }

  Widget buildContent() {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        ProfileScreen()
      ],
    );
  }

  Widget buildHandle() {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget buildSomething() {
    return Container();
  }
}
