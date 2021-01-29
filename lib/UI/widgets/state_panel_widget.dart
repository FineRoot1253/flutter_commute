import 'package:commute/UI/register_screen.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:commute/data/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatePanelWidget extends StatelessWidget {
  final _controller = AController.to;

  Color _color;
  String _content;
  IconData _iconData;

  StatePanelWidget(this._color, this._content, this._iconData);

  factory StatePanelWidget.fromUserState(UserState state) {
    StatePanelWidget statePanelWidget;
    switch (state) {
      case UserState.certificated_onDuty:
        statePanelWidget = StatePanelWidget(Colors.blue[800], "출근중", Icons.check);
        break;
      case UserState.certificated_offDuty:
        statePanelWidget = StatePanelWidget(Colors.grey[500], "퇴근중", Icons.check);
        break;
      case UserState.register_required:
        statePanelWidget = StatePanelWidget(Colors.red[400], "등록필요", Icons.error);
        break;
      case UserState.network_required:
        statePanelWidget =
            StatePanelWidget(Colors.red[400], "근무지 이탈중!", Icons.wrong_location_sharp);
        break;
      default:
        statePanelWidget =
            StatePanelWidget(Colors.white, " ", Icons.autorenew);
    }
    return statePanelWidget;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: GetBuilder<AController>(
                    builder: (_) => (this._iconData == Icons.check) ?
                    Text(_.calculateTimeDiff()) :
                    Container(height : 0.0, width: 0.0),
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
