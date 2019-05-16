import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:epub/epub.dart' as epub;

void main() => runApp(MyApp(post: fetchBook()));

class MyApp extends StatelessWidget {
  final Future<epub.EpubBookRef> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Epub Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Epub Example'),
        ),
        body: Center(
          child: FutureBuilder<epub.EpubBookRef>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.Title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

Future<epub.EpubBookRef> fetchBook() async {
  // Hard coded to Alice Adventures In Wonderland in Project Gutenberb
  final response =
      await http.get('https://www.gutenberg.org/ebooks/11.epub.images');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the EPUB
    return epub.EpubReader.openBook(response.bodyBytes);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load epub');
  }
}
