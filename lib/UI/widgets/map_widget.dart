import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final CameraPosition _center;

  MapWidget(this._center) : assert(_center == null);

  Completer<GoogleMapController> _ctrl = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _ctrl.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.6,
      height: Get.height * 0.4,
      child: GoogleMap(
          mapType: MapType.hybrid,
          onMapCreated: this._onMapCreated,
          initialCameraPosition: this._center),
    );
  }
}
