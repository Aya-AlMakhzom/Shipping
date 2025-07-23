import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/api_service.dart.dart';
import '../controller/questions_controller.dart';
import '../model/QuestionModel.dart';
import '../widgets/custom_dropdown_form_field.dart';

class QuestionsView extends StatelessWidget {
  final int categoryId;
  final int shipmentId;
  const QuestionsView({super.key, required this.categoryId, required this.shipmentId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionsController(categoryId));
    // Map to hold answers for each question
    final answers = <int, dynamic>{}.obs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF334EAC),
        title: const Text("أسئلة إضافية"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text(controller.error.value!));
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة في الأعلى
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/Bill-of-LP-Image-1.webp",
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "يرجى تعبئة الأسئلة الإضافية",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "هذه الأسئلة مطلوبة حسب نوع التصنيف الذي اخترته.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ...controller.questions.map((q) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Obx(() => buildQuestionField(
                      q: q,
                      answer: answers[q.id],
                      onChanged: (val) => answers[q.id] = val,
                    )),
                  )
                ).toList(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final answersList = answers.entries.map((entry) {
                      return {
                        'question_id': entry.key,
                        'answer': entry.value,
                      };
                    }).toList();

                    await ApiService.postShipmentAnswers(
                      shipmentId: shipmentId,
                      answers: answersList,
                    );
                  },
                  child: const Text("إرسال الإجابات"),
                ),


              ],
            ),
          ),
        );
      }),
    );
  }
} 