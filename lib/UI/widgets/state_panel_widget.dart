import 'package:commute/UI/screen.dart';
import 'package:commute/UI/widgets/widget.dart';
import 'package:commute/controller/controller.dart';
import 'package:commute/data/models/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatePanelWidget extends StatelessWidget {
  final _controller = AController.to;

  Color _color;
  String _content;
  IconData _iconData;

  StatePanelWidget(this._color, this._content, this._iconData);

  factory StatePanelWidget.fromUserState(int index) {
    StatePanelWidget statePanelWidget;
    print("새로 생성 : $index");
    switch (index) {
      case 1:
        statePanelWidget = StatePanelWidget(
            Colors.red[400], "근무지 이탈중!", Icons.wrong_location_sharp);
        break;
      case 2:
        statePanelWidget =
            StatePanelWidget(Colors.red[400], "등록필요", Icons.error);
        break;
      case 3:
        statePanelWidget = StatePanelWidget(
            Colors.red[400], "위치 권한 필요!", Icons.not_listed_location_sharp);
        break;
      case 5:
        statePanelWidget =
            StatePanelWidget(Colors.grey[500], "퇴근중", Icons.home);
        break;
      case 6:
        statePanelWidget =
            StatePanelWidget(Colors.blue[800], "출근중", Icons.check);
        break;
      case 7:
        statePanelWidget =
            StatePanelWidget(Colors.green[500], "외근중", Icons.directions_car);
        break;
      default:
        statePanelWidget = StatePanelWidget(Colors.white, " ", Icons.autorenew);
    }
    return statePanelWidget;
  }

  @override
  Widget build(BuildContext context) {
   if(this._iconData == Icons.check) {
     distanceCheck();
   }
    return Stack(overflow: Overflow.visible, children: [
      CustomPaint(
        size: Get.size,
        painter: CurvePainter(this._color),
      ),
      Positioned.fill(
          child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.13),
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
            padding: EdgeInsets.only(top: Get.height * 0.21),
            child: SizedBox(
              width: Get.width * 0.5,
              height: Get.height * 0.12,
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
          padding: EdgeInsets.only(top: Get.height * 0.19),
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
