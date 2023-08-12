class PlacePredictions {
  late String display_name;
  late String placeId;
  late String name;
  PlacePredictions({this.display_name = "", this.placeId = "", this.name = ""});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"].toString();
    display_name = json["display_name"];
    name = json["name"];
  }
}
