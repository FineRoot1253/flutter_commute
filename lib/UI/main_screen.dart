import 'dart:io';

import 'package:commute/UI/profile_screen.dart';
import 'package:commute/UI/widgets/state_panel_widget.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:commute/controller/time_counter_controller.dart';
import 'package:commute/data/models/enums.dart';
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
    // if (_controller.user !=null &&_controller.user.isCommuted) {
    //   _controller.startTimer();
    //   if (_controller.toggleList[0])
    //     _controller.toggleList = _controller.toggleList.reversed.toList();
    //   print("초기 근태 체크 : ${_controller.user.isCommuted}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            height: Get.height - MediaQuery
                .of(context)
                .padding
                .top,
            child: FutureBuilder(
                future: result,
                builder: (context, snapshot){
                  print(result);
                  if(snapshot.hasData)return buildMainContent();
                  if(snapshot.hasError)return Center(
                    child: Text("error : \n${snapshot.error.toString()}"),);
                  return Center(child: CircularProgressIndicator(),);
                }
            ),
          ),
        ));
  }

  Widget buildMainContent(){
    return Stack(
      overflow: Overflow.visible,
      children: [
        buildBackGround(_controller.user.state),
        GetBuilder<AController>(
          builder:(_) => AnimatedPositioned(
              top: (_.user.isCommuted) ? 0 : -Get.height,
              duration: Duration(milliseconds: 1200),
              curve: Curves.bounceOut,
              onEnd: () {
                //TODO : startTimeDiffTimer
                _timerController.toggle = _controller.user.isCommuted;
                _timerController.startTimer();
              },
              child: _.user.statePanelWidget),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: Get.height * 0.05),
            child: GetBuilder<AController>(
                initState: (_){
                  if(_controller.user.isCommuted) {
                    _controller.toggleList =
                        _controller.toggleList.reversed.toList();
                    _timerController.toggle = _controller.user.isCommuted;
                    _timerController.startTimer();
                  }
                },
                builder:(_) =>buildBtn())
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.095,
            minChildSize: 0.085,
            maxChildSize: 0.4,
            builder: (context, controller) =>
                Stack(
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
                                  borderRadius: BorderRadius.circular(
                                      24)),
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
    );
  }

  Widget buildBackGround(UserState state){
    switch(state){
      case UserState.certificated_onDuty:
      case UserState.certificated_offDuty:
        return StatePanelWidget.fromUserState(UserState.certificated_offDuty);
      default :
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
    return ToggleButtons(
      isSelected: _controller.toggleList,
      children: <Widget>[
        Icon(Icons.home),
        Icon(Icons.apartment)
      ],
      onPressed: (int index) async {
        if (!_controller.toggleList[index]) {
          _controller.user.isCommuted = !_controller.user.isCommuted;
          await _controller.updateUserData();
          _controller.toggleList = _controller.toggleList.reversed.toList();
          _controller.update();
        }
      },
    );
  }

  Widget buildBtn() {
    switch(_controller.user.state){
      case UserState.certificated_offDuty:
        return buildToggleBtns(false);
        break;
      case UserState.certificated_onDuty: // togglebtn() needed
        return buildToggleBtns(true);
        break;
      case UserState.register_required: // Get.to("/register") needed
          return buildFlatBtn((){
            Get.toNamed('/register');
          });
        break;
      case UserState.network_required: // exit(0) logic needed
        return buildFlatBtn((){
          if(Platform.isAndroid) exit(0);
          else SystemNavigator.pop();
        });
        break;
      default:
        return Container();
        break;
    }
  }


  Widget buildFlatBtn(Function func){
    return RaisedButton(onPressed: func, child: Text("확인"),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),);
  }

}
