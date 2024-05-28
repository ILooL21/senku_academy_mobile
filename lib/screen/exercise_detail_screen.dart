import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_navbar.dart';
import 'package:senku_academy_mobile/controllers/exercise_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:senku_academy_mobile/base_url.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String id;
  const ExerciseDetailScreen({super.key, required this.id});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Map<String, dynamic> questions = {};
  List<dynamic> options = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var response = await ExerciseController.getExercise(widget.id);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      var fetchedOptions = data['options'];
      var fetchedQuestions = data['question'];
      fetchedOptions.shuffle();
      setState(() {
        options = fetchedOptions;
        questions = fetchedQuestions;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitAnswer(int answer) async {
    var response = await ExerciseController.answerExercise(widget.id, answer);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String title;
      String content;

      if (data['msg'] == 'Correct Answer') {
        title = 'Jawaban Benar';
        content = 'Jawabanmu Benar!';
      } else {
        title = 'Jawaban Salah';
        content =
            'Jawabanmu salah. Jawaban yang benar adalah ${data['answer']['option']}';
      }
      showAlert(context, title, content);
    } else {
      showAlert(context, 'Error', 'Failed to submit answer.');
    }
  }

  void showAlert(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              const SizedBox(height: 10),
              if (questions['explanation'] != null)
                Image.network(
                  "$baseURL/explanation/${questions['explanation']}",
                  width: 200,
                  height: 200,
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/chapter/${questions['chapter_id']}');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Senku Academy',
          style: TextStyles.title,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const Navbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              :
              // jika options kosong atau kurang dari 4 maka tampilkan pesan error
              options.length < 4
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Soal belum siap',
                          textAlign: TextAlign.center,
                          style: TextStyles.title.copyWith(
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/chapter/${questions['chapter_id']}');
                          },
                          child: const Text('Kembali'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          questions['title'] ?? 'No Title',
                          textAlign: TextAlign.center,
                          style: TextStyles.title.copyWith(
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image.network(
                          "$baseURL/question/${questions['question']}",
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        if (options.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: options
                                .map((option) => Card(
                                      child: ListTile(
                                        title: Text(option['option']),
                                        onTap: () {
                                          submitAnswer(option['id']);
                                        },
                                      ),
                                    ))
                                .toList(),
                          )
                        else
                          Text(
                            'No Options',
                            style: TextStyles.title.copyWith(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}
