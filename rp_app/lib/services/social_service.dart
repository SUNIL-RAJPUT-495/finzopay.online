import 'api_service.dart';
import '../models/social_model.dart';

class SocialService {
  final ApiService _api = ApiService();

  Future<SocialModel> getLinks() async{
    final res = await _api.get("/social-links");
    return SocialModel.fromJson(res['data'] ?? {});
  }
}
