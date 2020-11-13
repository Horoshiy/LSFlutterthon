
import 'dart:io';
import 'package:http/http.dart';

class Network {

  Network(this.url);

  final String url;
  
  Future getData() async {
    // Add error handling
    try {
      print('Calling uri: $url');
      final response = await get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Response status code: ${response.statusCode}');
      }
    } on SocketException {
      print('No Internet connection 😑');
    } on HttpException {
      print("Couldn't find the post 😱");
    } on FormatException {
      print('Bad response format 👎');
    }
  }
}