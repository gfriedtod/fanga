import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/screens/reader.dart';
import 'package:manga_reader/state/base_provider.dart';

class LelscanReaderProvider extends BaseProvider {
  List<String> pages = [];


  getPages(String catalogName,Chapter chapter,BuildContext context,Manga manga) async{
    lelscanService.chapterPages(catalogName, chapter).then((value) {
      print(value);
      this.pages = value;
      precacheImage(NetworkImage(pages[0]), context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
    }).catchError((onError){
      print(onError);
    });
  }
}