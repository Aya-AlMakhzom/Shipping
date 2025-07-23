import 'package:get/get.dart';
import '../api_service.dart.dart';
import '../model/QuestionModel.dart';

class QuestionsController extends GetxController {
  final int categoryId;
  QuestionsController(this.categoryId);

  var isLoading = false.obs;
  var questions = <QuestionModel>[].obs;
  var error = RxnString();

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  void fetchQuestions() async {
    isLoading.value = true;
    error.value = null;
    try {
      final result = await ApiService.getQuestionsByCategory(categoryId);
      questions.value = result;
      if (result.isEmpty) {
        error.value = 'لا توجد أسئلة متاحة لهذا التصنيف.';
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب الأسئلة: $e");
      error.value = 'فشل في جلب الأسئلة';
    } finally {
      isLoading.value = false;
    }
  }
} 