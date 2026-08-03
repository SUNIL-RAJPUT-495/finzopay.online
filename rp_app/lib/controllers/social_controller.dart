import 'package:get/get.dart';
import '../models/social_model.dart';
import '../services/social_service.dart';

class SocialController extends GetxController {

  final SocialService service = SocialService();

  var loading=true.obs;
  SocialModel? links;

  @override
  void onInit(){
    load();
    super.onInit();
  }

  load() async{
    loading.value=true;
    links = await service.getLinks();
    loading.value=false;
  }
}
