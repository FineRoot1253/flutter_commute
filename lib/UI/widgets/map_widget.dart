import 'dart:async';

import 'package:commute/controller/a_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final CameraPosition _center;

  MapWidget(this._center) : assert(_center != null);

  Completer<GoogleMapController> _ctrl = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _ctrl.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.height * 0.3,
      height: Get.height * 0.3,
      child: GoogleMap(
          circles: AController.to.circleSet,
          markers: AController.to.markerSet,
          mapType: MapType.normal,
          onMapCreated: this._onMapCreated,
          initialCameraPosition: this._center),
    );
  }
}
