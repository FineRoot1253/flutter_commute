import 'package:commute/UI/register_screen.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:commute/controller/time_counter_controller.dart';
import 'package:commute/data/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatePanelWidget extends StatelessWidget {
  final _controller = AController.to;

  Color _color;
  String _content;
  IconData _iconData;

  StatePanelWidget(this._color, this._content, this._iconData);

  factory StatePanelWidget.fromUserState(UserState state) {
    StatePanelWidget statePanelWidget;
    switch (state) {
      case UserState.certificated_onWork:
        statePanelWidget =
            StatePanelWidget(Colors.blue[800], "출근중", Icons.check);
        break;
      case UserState.certificated_beforeWork:
        statePanelWidget =
            StatePanelWidget(Colors.grey[500], "퇴근중", Icons.home);
        break;
      case UserState.certificated_workOnOutside:
        statePanelWidget =
            StatePanelWidget(Colors.green[500], "외근중", Icons.directions_car);
        break;
      case UserState.register_required:
        statePanelWidget =
            StatePanelWidget(Colors.red[400], "등록필요", Icons.error);
        break;
      case UserState.network_required:
        statePanelWidget = StatePanelWidget(
            Colors.red[400], "근무지 이탈중!", Icons.wrong_location_sharp);
        break;
      default:
        statePanelWidget = StatePanelWidget(Colors.white, " ", Icons.autorenew);
    }
    return statePanelWidget;
  }

  @override
  Widget build(BuildContext context) {
    print(this._controller.user.state);
    return Stack(overflow: Overflow.visible, children: [
      CustomPaint(
        size: Get.size,
        painter: CurvePainter(this._color),
      ),
      Positioned.fill(
          child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.17),
          child: Text(
            "${this._content}",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
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
                  child: GetBuilder<TimeCounterController>(
                    init: TimeCounterController(),
                    builder: (_) => (this._controller.user.state ==
                            UserState.certificated_onWork)
                        ? Text(_.calculateTimeDiff(
                            this._controller.user.lastUpdateAt.toLocal()))
                        : Text(this._content + "인 상태입니다."),
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
              child: Icon(this._iconData, color: this._color),
            ),
          ),
        ),
      )),
    ]);
  }
}
