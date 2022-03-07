class MetricsResponse {
  final double lastAirTemp;
  final double minAirTemp;
  final double maxAirTemp;
  final double lastSkinTemp;
  final double minSkinTemp;
  final double maxSkinTemp;
  final double lastHumidity;
  final double maxHumidity;
  final double minHumidity;

  MetricsResponse(
      this.lastAirTemp,
      this.minAirTemp,
      this.maxAirTemp,
      this.lastSkinTemp,
      this.minSkinTemp,
      this.maxSkinTemp,
      this.lastHumidity,
      this.maxHumidity,
      this.minHumidity
      );

  MetricsResponse.fromJson(Map<String, dynamic> parsedJson) :
      lastAirTemp = parsedJson['last_air_temp'].toDouble(),
      minAirTemp = parsedJson['min_air_temp'].toDouble(),
      maxAirTemp = parsedJson['max_air_temp'].toDouble(),
      lastSkinTemp = parsedJson['last_skin_temp'].toDouble(),
      minSkinTemp = parsedJson['min_skin_temp'].toDouble(),
      maxSkinTemp = parsedJson['max_skin_temp'].toDouble(),
      lastHumidity = parsedJson['last_humidity'].toDouble(),
      maxHumidity = parsedJson['min_humidity'].toDouble(),
      minHumidity = parsedJson['max_humidity'].toDouble();
}