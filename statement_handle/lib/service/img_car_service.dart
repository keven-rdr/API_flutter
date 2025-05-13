import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart'; // ajuste o caminho se necessário

class ImgCarService {
  static Future<String?> fetchCarImage(String make, String model) async {
    final query = '$make $model car';
    final url = Uri.parse(
      'https://serpapi.com/search.json?q=${Uri.encodeComponent(query)}&tbm=isch&api_key=${Env.SERPAPI_KEY}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final images = json['images_results'];
      if (images != null && images.isNotEmpty) {
        return images[0]['original'];
      }
    }

    return null;
  }
}
