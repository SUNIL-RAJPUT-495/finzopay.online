import '../services/api_service.dart';
import '../models/home_model.dart';

class HomeService {
  final ApiService _apiService = ApiService();

  Future<HomeModel> getHomeData() async {
    final response = await _apiService.get("/home");
    return HomeModel.fromJson(response['data']);
  }
}
