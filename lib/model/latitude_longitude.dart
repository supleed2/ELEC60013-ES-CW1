class LatitudeLongitude {
  final double latitude;
  final double longitude;

  LatitudeLongitude(this.latitude, this.longitude);

  LatitudeLongitude.fromJson(Map<String, dynamic> parsedJson):
    latitude = parsedJson['latitude'], longitude = parsedJson['longitude'];
}
