
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// class AssistantMethods {
//   static Future<String> searchCoordinateAddress(Position position) async {
//     String placeAddress = "";
//     placeAddress =
//         "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat="+position.latitude.toString()+"&lon="position.longitude.toString();
//     print(placeAddress);
//     //String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
//     //var response = await RequestAssistant.getRequest(url);
//     // if (response != "Fail" && response["status"] == "OK") {
//     //   var results = response["results"];
//     //   if (results != null && results.isNotEmpty) {
//     //     var firstResult = results[0];
//     //     placeAddress = firstResult["formatted_address"];
//     //   }
//     // }
//     // print(response); // In ra để kiểm tra dữ liệu JSON bạn nhận được
//     // if (response != "Fail") {
//     //   placeAddress = response["result"][0]["format_address"];
//     // }
//     return placeAddress;
//   }
// }

class AssistantMethods {
  static Future<String> searchCoordinateAddress(//!lấy thông tin địa chỉ từ tọa độ 
      Position position, context) async {
    String lat = position.latitude.toString();
    String lon = position.longitude.toString();
    String placeAddress = "";

    String nominatimURL = "https://nominatim.openstreetmap.org/reverse";

    Map<String, String> queryParams = {
      "lat": lat,
      "lon": lon,
      "format": "json",
    };

    String queryString = Uri(queryParameters: queryParams).query;
    nominatimURL += '?$queryString';

    Map<String, String> headers = {
      "User-Agent": "YourAppName", // Replace with your app's name
    };

    final response = await http.get(Uri.parse(nominatimURL), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      //placeAddress = jsonResponse["display_name"];
      placeAddress = jsonResponse["name"];

      Address userPickUpAddress = Address();
      userPickUpAddress.longtitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    } else {
      print("Request failed with status: ${response.statusCode}");
    }

    return placeAddress;
  }
}
