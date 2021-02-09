class Place {

  String addr;
  String addr1;
  String addr2;
  String lng;
  String lat;

  Place(this.addr,this.addr1,this.addr2,this.lat,this.lng);

  Place.fromNative();
  factory Place.fromJson(){}

}