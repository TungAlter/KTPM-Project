class PlacePredictions {
  late String display_name;
  late String placeId;
  late String name;
  late double lat;
  late double lon;
  PlacePredictions(
      {this.display_name = "",
      this.placeId = "",
      this.name = "",
      required this.lat,
      required this.lon});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"].toString();
    display_name = json["display_name"];
    name = json["name"];
    lat = double.parse(json["lat"]);
    lon = double.parse(json["lon"]);
  }
}
