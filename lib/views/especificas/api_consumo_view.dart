import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiConsumoView extends StatefulWidget {
  const ApiConsumoView({super.key});

  @override
  State<ApiConsumoView> createState() => _ApiConsumoViewState();
}

class _ApiConsumoViewState extends State<ApiConsumoView> {
  late Future<List<_ApiPost>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = _loadPosts();
  }

  Future<List<_ApiPost>> _loadPosts() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=8'),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao consumir a API');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map(
          (item) => _ApiPost(
            title: item['title']?.toString() ?? '',
            body: item['body']?.toString() ?? '',
          ),
        )
        .toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _futurePosts = _loadPosts();
    });
    await _futurePosts;
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A5F);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API REST'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<_ApiPost>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Nao foi possivel carregar a API.')),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final posts = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Consumo de API REST externa usando http e JSONPlaceholder.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...posts.map(
                  (post) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.api, color: primaryColor),
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ApiPost {
  _ApiPost({required this.title, required this.body});

  final String title;
  final String body;
}