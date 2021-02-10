import 'package:commute/common/keywords.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location{

  Marker _marker;
  Circle _circle;

  Location({LatLng latLng, String locationId}){
    String uId = locationId ?? COMP_ID;
    LatLng _latLng = latLng ?? LatLng(0.0, 0.0);
    this._marker = Marker(markerId: MarkerId(uId),position: _latLng);
    this._circle = Circle(circleId: CircleId(uId),center: _latLng,radius: 1000);
  }

  Marker get marker => this._marker;
  Circle get circle => this._circle;

  calculateDistanceDiff(Position aPosition) => Geolocator.distanceBetween(this._marker.position.latitude, this._marker.position.longitude, aPosition.latitude, aPosition.longitude);

}