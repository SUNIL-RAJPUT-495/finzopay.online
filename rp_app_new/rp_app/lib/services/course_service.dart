import '../models/course_model.dart';
import 'api_service.dart';

class CourseService {
  final ApiService _apiService = ApiService();

  /// Fetch courses by type (security, purchase, selling)
  Future<List<CourseModel>> getCoursesByType(String type) async {
    try {
      final response = await _apiService.get('/courses?type=$type');

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> coursesJson = response['data'];
        return coursesJson.map((json) => CourseModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }
}
