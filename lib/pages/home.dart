import 'package:flutter/material.dart';
import 'package:giff_app/logic/api.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GiphyApi giphyApi = GiphyApi();
  int _offset = 0;
  String _search = 'cat';
  List gifs = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();



  void onSearch() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _search = _searchController.text;
        _offset = 0;
        giphyApi.getGifs(_search, _offset, gifs).then((updatedGifs) {
          setState(() {
            gifs = updatedGifs;
          });
        });
      });
    });
  }

  void onScrollEnd() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _offset += 25;
        giphyApi.getGifs(_search, _offset, gifs).then((updatedGifs) {
          setState(() {
            gifs = updatedGifs;
          });
        });
      });
    }
  }



  @override
  void initState() {

    super.initState();
    _scrollController.addListener(onScrollEnd);
    _searchController.addListener(onSearch);
    giphyApi.getGifs(_search, _offset, gifs).then((updatedGifs) {
      setState(() {
        gifs = updatedGifs;
      }); // loading cats so that the screen wouldn't be blank
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gif Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: gifs.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                String gifUrl = gifs[index]['images']['fixed_height']['url'];
                return GridTile(
                  child: Image.network(
                    gifUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//https://www.youtube.com/watch?v=vodctqWbJCU&list=PL9n0l8rSshSnJg9WZAX3XmHZuqt1OnjUB&index=4