import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
   
    return MaterialApp(
    title:"Manga Recommendation",
    debugShowCheckedModeBanner: false,
    home: Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}
class HomeState extends State<Home> {
  List<dynamic> animeImg = [];
  String imageUrl= "";
 

  @override
  initState() {
    super.initState();
    getImg();
  }

  Future<void> getImg() async {
    var url = Uri.parse("https://api.jikan.moe/v4/recommendations/manga");
    var response = await http.get(url);

    setState(() {
      animeImg = json.decode(response.body)["data"];
    });

    if (animeImg.isEmpty) {
      print("Error: No images fetched!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manga Recommendation"),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: animeImg.length > 18 ? 18 : animeImg.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                imageUrl = animeImg[index]["entry"][0]["images"]["jpg"]["large_image_url"];
              });
              
              Navigator.push(context,
                            MaterialPageRoute(
                            builder: (context) => SecondPage(imageUrl:imageUrl)));
            },
            child:Image.network(
              animeImg[index]["entry"][0]["images"]["jpg"]["large_image_url"],
              width: 100,
              height: 100
            )
          );
        },
      ),
    );
  }
}


class SecondPage extends StatelessWidget {
  final String imageUrl;
  const SecondPage({required this.imageUrl});
  @override 
  Widget build (BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title:const Text("Manga Recommendation"),
      backgroundColor:Colors.blue
      ),
      body:Center(
      child: imageUrl.isNotEmpty
        ? Image.network(imageUrl)
        :const Text("No Image Selected")
      )
    );
  }
}