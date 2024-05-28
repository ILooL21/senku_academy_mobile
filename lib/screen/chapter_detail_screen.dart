import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:senku_academy_mobile/controllers/chapter_controller.dart';

class ChapterDetailScreen extends StatefulWidget {
  final String id;
  const ChapterDetailScreen({super.key, required this.id});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  Map<String, dynamic> chapter = {};
  List<dynamic> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var response = await ChapterController.getChapter(widget.id);
    var data = json.decode(response.body)['data'];
    var fetchedChapter = data['chapter'];
    var fetchedQuestions = data['questions'];
    setState(() {
      chapter = fetchedChapter;
      questions = fetchedQuestions;
      isLoading = false;
    });
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    chapter['name'] ?? '',
                    style: TextStyles.title.copyWith(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    chapter['description'] ?? '',
                    textAlign: TextAlign.justify,
                    style: TextStyles.title.copyWith(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Latihan Soal',
                    style: TextStyles.title,
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : questions.isEmpty
                          ? const Center(
                              child: Text('Belum ada soal'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Center(
                                      child: Text(
                                        questions[index]['title'],
                                        style: TextStyles.title,
                                      ),
                                    ),
                                    onTap: () {
                                      context.go(
                                          '/question/${questions[index]['id']}');
                                    },
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/lesson/${chapter['lesson_id']}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
