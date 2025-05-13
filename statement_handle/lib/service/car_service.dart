import 'package:statement_handle/models/car.dart';
import 'package:statement_handle/utils/ApiService.dart';

class CarService {
  // Usando a API do NHTSA para veículos
  static Future<ApiResponse<List<Car>>> loadCars() async {
    // Esta é uma API pública que funciona bem
    var url = "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/honda?format=json";

    var response = await ApiService.request<List<Car>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) {
        if (json['Results'] != null) {
          return (json['Results'] as List).map((item) {
            // Criando objetos Car a partir da resposta da API
            return Car.fromJson({
              'name': '${item['Make_Name']} ${item['Model_Name']}',
              'description': 'Modelo ID: ${item['Model_ID']}, ${item['VehicleTypeId'] != null ? 'Tipo: ${item['VehicleTypeId']}' : 'Sedan/Hatchback'}',
              'imageUrl': '',
              'price': '${45000 + (item['Model_ID'] % 30000)}' // Preço fictício baseado no ID do modelo
            });
          }).toList();
        }
        return [];
      },
    );

    return response;
  }
}
