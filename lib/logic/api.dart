import 'dart:convert';

import 'package:http/http.dart';

class GiphyApi {
  Future<List> getGifs(String _search, int _offset, List gifs) async {
    Response response = await get(Uri.parse(
        'https://api.giphy.com/v1/gifs/search?api_key=UFb15Ns2Vx8xHzzxd1GOUeMjxq6FvMGI&q=$_search&limit=25&offset=$_offset'));
    Map gifData = jsonDecode(response.body);

      if(_offset == 0){
        return gifs = gifData['data'];
      }
      else {
        gifs.addAll(gifData['data']);
        return List.from(gifs);
      }
  }
}
//https://github.com/felipecastrosales/Gif-Finder/blob/master/lib/ui/home_page.dart
//https://www.youtube.com/watch?v=WdXcJdhWcEY&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ&index=26