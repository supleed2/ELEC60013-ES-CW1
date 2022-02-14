class LatitudeLongitude {
  double latitude;
  double longitude;

  LatitudeLongitude(this.latitude, this.longitude);

  factory LatitudeLongitude.fromJson(Map<String, dynamic> parsedJson){
    return LatitudeLongitude(parsedJson['latitude'], parsedJson['longitude']);
  }
}
