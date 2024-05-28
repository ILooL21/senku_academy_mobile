import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:senku_academy_mobile/styles.dart';
import 'package:senku_academy_mobile/widget/custom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:senku_academy_mobile/controllers/category_controller.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String id;
  const CategoryDetailScreen({super.key, required this.id});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<dynamic> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var response = await CategoryController.getCategory(widget.id);
    var data = json.decode(response.body)['lessons'];
    setState(() {
      lessons = data;
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
                  const Text('List Kelas', style: TextStyles.title),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : lessons.isEmpty
                          ? const Center(
                              child: Text(
                                'Tidak ada kelas tersedia',
                                style: TextStyles.subtitle,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: lessons.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Center(
                                        child: Text(lessons[index]['name'])),
                                    onTap: () => {
                                      context
                                          .go('/lesson/${lessons[index]['id']}')
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
              onPressed: () {
                context.go('/home');
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
