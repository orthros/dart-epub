import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:epub/epub.dart' as epub;

void main() => runApp(EpubWidget());

class EpubWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EpubState();
  }
}

class EpubState extends State<EpubWidget> {
  Future<epub.EpubBookRef> book;

  final _urlController = TextEditingController();

  void fetchBookButton() {
    setState(() {
      book = fetchBook(_urlController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Fetch Epub Example",
        home: new Material(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Epub Inspector',
                      style: new TextStyle(fontSize: 25.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 50.0)),
                    new Text(
                      'Enter the Url of an Epub to view some of it\'s metadata.',
                      style: new TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0)),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Enter Url",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Url cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: fetchBookButton,
                      child: new Text("Inspect Book"),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25.0)),
                    Center(
                      child: FutureBuilder<epub.EpubBookRef>(
                        future: book,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return new Material(
                                color: Colors.white,
                                child: buildEpubWidget(snapshot.data));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          // By default, show a loading spinner
                          // return CircularProgressIndicator();

                          // By default, show just empty.
                          return Container();
                        },
                      ),
                    ),
                  ])),
                ))));
  }
}

Widget buildEpubWidget(epub.EpubBookRef book) {
  return Container(
      child: new Column(
    children: <Widget>[
      Text(
        "Title",
        style: TextStyle(fontSize: 20.0),
      ),
      Text(
        book.Title,
        style: TextStyle(fontSize: 15.0),
      ),
      new Padding(
        padding: EdgeInsets.only(top: 15.0),
      ),
      Text(
        "Author",
        style: TextStyle(fontSize: 20.0),
      ),
      Text(
        book.Author,
        style: TextStyle(fontSize: 15.0),
      )
    ],
  ));
}

// Needs a url to a valid url to an epub like 'https://www.gutenberg.org/ebooks/11.epub.images'
Future<epub.EpubBookRef> fetchBook(String url) async {
  // Hard coded to Alice Adventures In Wonderland in Project Gutenberb
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the EPUB
    return epub.EpubReader.openBook(response.bodyBytes);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load epub');
  }
}
