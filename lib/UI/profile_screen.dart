import 'package:commute/UI/widgets/map_widget.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileScreen extends StatelessWidget {

  final _controller = AController.to;

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [
      Center(child: Text("Profile",style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),),),
      SizedBox(height: 20,),
      ListTile(
        title: Text("User Uuid",
            style: TextStyle(
            fontWeight: FontWeight.bold,
        )),
        trailing: Text("${_controller.user.userId}"),
      ),
      ListTile(
        title: Text("이름",
            style: TextStyle(
            fontWeight: FontWeight.bold,
        )),
        trailing: Text("${_controller.user.name}"),
      ),
      ListTile(
        title: Text("최근 접속 일",
            style: TextStyle(
            fontWeight: FontWeight.bold,
        )),
        trailing: Text("${_controller.dateTimeParseToString(_controller.user.lastUpdateAt)}"),
      ),
    ],),);
  }
}
