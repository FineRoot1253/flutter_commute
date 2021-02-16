import 'package:commute/common/keywords.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location{

  Marker _marker;
  Circle _circle;

  Location({LatLng latLng, String locationId, String title}){
    String uId = locationId ?? COMP_ID;
    String contentTitle = title ?? "unknown target";
    BitmapDescriptor icon = title.startsWith("근무지") ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure) : BitmapDescriptor.defaultMarker;
    LatLng _latLng = latLng ?? LatLng(0.0, 0.0);
    this._marker = Marker(markerId: MarkerId(uId),position: _latLng,infoWindow: InfoWindow(title: contentTitle),icon: icon);
    this._circle = Circle(circleId: CircleId(uId),center: _latLng,radius: 150,fillColor: Colors.blue[400].withOpacity(0.4),strokeWidth: 0);
  }

  Marker get marker => this._marker;
  Circle get circle => this._circle;

}