import 'package:get/get.dart';
import '../services/support_service.dart';

class SupportController extends GetxController {

  final SupportService service = SupportService();

  var loading = false.obs;

  // callback for clearing form
  Function()? clearForm;

  submit({
    required String name,
    required String phone,
    required String message,
  }) async {

    if (message.trim().isEmpty) {
      Get.snackbar("Error", "Please enter your query");
      return;
    }

    loading.value = true;

    try {
      await service.submitSupport({
        "name": name,
        "phone": phone,
        "message": message,
      });

      Get.snackbar(
        "Success",
        "Query raised successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      // ✅ Clear form
      clearForm?.call();

    } catch (e) {
      Get.snackbar("Error", "Submission failed");
    }

    loading.value = false;
  }
}
