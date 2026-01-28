import 'package:domain/models/article.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab_4/pages/article/widgets/tag.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleController extends GetxController{
  Article article;
  ArticleController({required this.article});

  String timeAgo() {
    final DateTime time1 = DateTime.parse(article.author.created_at);
    return timeago.format(time1);
  }

  String numberFormat(int number) {
    if(number>1000000){
      return "${(number/1000000.0).toStringAsFixed(1)}M";
    }
    else if(number>1000){
      return "${(number/1000.0).toStringAsFixed(1)}K";
    }
    return "${number}";
  }

  String getViews(){
    print(article.views_count.toString());
    return numberFormat(article.views_count);
  }

  String getLikes(){
    return numberFormat(article.likes_count);
  }

  String getComments(){
    return numberFormat(article.comments_count);
  }

  List<Widget> getTags(){
    List<Widget> list = article.tags.map((tag) => Tag(content: "#${tag}")).toList();
    return list;
  }
}
