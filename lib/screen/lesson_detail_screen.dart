import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:senku_academy_mobile/controllers/lesson_controller.dart';

class LessonDetailScreen extends StatefulWidget {
  final String id;
  const LessonDetailScreen({super.key, required this.id});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  Map<String, dynamic> lesson = {};
  List<dynamic> chapters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var response = await LessonController.getLesson(widget.id);
    var data = json.decode(response.body)["data"];
    var fetchedLesson = data["lesson"];
    var fetchedChapters = data["chapters"];
    setState(() {
      lesson = fetchedLesson;
      chapters = fetchedChapters;
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    lesson["name"] ?? "",
                    style: TextStyles.title.copyWith(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lesson["description"] ?? "",
                    textAlign: TextAlign.justify,
                    style: TextStyles.title.copyWith(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Daftar Materi",
                    style: TextStyles.title,
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : chapters.isEmpty
                          ? const Center(
                              child: Text(
                                "Tidak ada kelas tersedia",
                                style: TextStyles.subtitle,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: chapters.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Center(
                                      child: Text(chapters[index]["name"]),
                                    ),
                                    onTap: () {
                                      context.go(
                                          '/chapter/${chapters[index]["id"]}');
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
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Change this to the appropriate category navigation
                context.go('/category/${lesson["category_id"]}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
