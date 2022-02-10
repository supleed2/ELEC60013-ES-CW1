class MetricsData{
  double currentReading, lowestReading, highestReading, minimumPossible, maximumPossible, lowCutOff, highCutOff;
  String metric, units;

  MetricsData(
      this.currentReading,
      this.lowestReading,
      this.highestReading,
      this.minimumPossible,
      this.maximumPossible,
      this.lowCutOff,
      this.highCutOff,
      this.metric,
      this.units
      );
}