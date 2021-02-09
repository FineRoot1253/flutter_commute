import 'dart:io';

import 'package:commute/UI/profile_screen.dart';
import 'package:commute/UI/widgets/state_panel_widget.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:commute/controller/time_counter_controller.dart';
import 'package:commute/data/models/enums.dart';
import 'package:commute/data/models/user_workOnOutside_model.dart';
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
  final _timerController = Get.put(TimeCounterController());
  Future result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = _controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: Get.height - MediaQuery.of(context).padding.top,
        child: FutureBuilder(
            future: result,
            builder: (context, snapshot) {
              print(result);
              if (snapshot.hasData) return buildMainContent();
              if (snapshot.hasError)
                return Center(
                  child: Text("error : \n${snapshot.error.toString()}"),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    ));
  }

  Widget buildMainContent() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        buildBackGround(_controller.user.state),
        GetBuilder<AController>(
          builder: (_) => AnimatedPositioned(
              top: (_.user.isCommuted) ? 0 : -Get.height,
              duration: Duration(milliseconds: 1200),
              curve: Curves.bounceOut,
              onEnd: () {
                //TODO : startTimeDiffTimer
                _timerController.toggle = _.user.isCommuted;
                _timerController.startTimer();
              },
              child: _.user.statePanelWidget),
        ),
        Center(
          child: Padding(
              padding: EdgeInsets.only(top: Get.height * 0.05),
              child: GetBuilder<AController>(
                  initState: (_) {
                    if (_controller.user.isCommuted) {
                      _controller.toggleList =
                          _controller.toggleList.reversed.toList();
                      _timerController.toggle = _controller.user.isCommuted;
                      _timerController.startTimer();
                    }
                  },
                  builder: (_) => buildBtn())),
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
                          padding: EdgeInsets.only(bottom: Get.height * 0.4),
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
    );
  }

  Widget buildBackGround(UserState state) {
    switch (state) {
      case UserState.certificated_onWork:
      case UserState.certificated_beforeWork:
      case UserState.certificated_workOnOutside:
        return StatePanelWidget.fromUserState(
            UserState.certificated_beforeWork);
      default:
        return _controller.user.statePanelWidget;
    }
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

  Widget buildToggleBtns(bool isOnDuty) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          isSelected: _controller.toggleList,
          children: <Widget>[
            Icon(Icons.home),
            Icon(Icons.apartment),
          ],
          onPressed: (int index) async {
            if (!_controller.toggleList[index]) {
              _controller.user.isCommuted = !_controller.user.isCommuted;
              _controller.user.state = _controller.user.isCommuted ? UserState.certificated_onWork : UserState.certificated_beforeWork;

              if(_controller.user.state == UserState.certificated_workOnOutside) await _controller.updateUserWorkTimeWhileOutside(); // 외근일 경우 외근 종료 업데이트

              await _controller.updateUserData();

              _controller.toggleList = _controller.toggleList.reversed.toList();
              _controller.update();
            }
          },
        ),
        FlatButton(
          onPressed: () async {
            if(!_controller.user.isCommuted) {
              _controller.user.isCommuted = !_controller.user.isCommuted;
              _controller.toggleList = _controller.toggleList.reversed.toList();
            }
            _controller.user.state = _controller.user.isCommuted ? UserState.certificated_workOnOutside : UserState.certificated_beforeWork;
            await _controller.updateUserData();
            await _controller.setUserWorkTimeWhileOutside();
            _controller.update();
          },
          child: Text(
            "외근 시작",
            style: TextStyle(color: Colors.green[700]),
          ),
          shape:
              RoundedRectangleBorder(
                side: BorderSide(color: Colors.green[500]),
                  borderRadius: BorderRadius.circular(15.0)
              ),
          splashColor: Colors.green[300],
        )
      ],
    );
  }

  Widget buildBtn() {
    switch (_controller.user.state) {
      case UserState.certificated_workOnOutside:
      case UserState.certificated_onWork: // togglebtn() needed
        return buildToggleBtns(true);
        break;
      case UserState.certificated_beforeWork:
        return buildToggleBtns(false);
      case UserState.register_required: // Get.to("/register") needed
        return buildFlatBtn(() {
          Get.toNamed('/register');
        });
        break;
      case UserState.network_required: // exit(0) logic needed
        return buildFlatBtn(() {
          if (Platform.isAndroid)
            SystemNavigator.pop();
          else
            exit(0);
        });
        break;
      default:
        return Container();
        break;
    }
  }

  Widget buildFlatBtn(Function func) {
    return RaisedButton(
      onPressed: func,
      child: Text("확인"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }
}
