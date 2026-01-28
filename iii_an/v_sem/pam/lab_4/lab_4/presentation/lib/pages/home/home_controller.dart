import 'package:domain/models/article.dart';
import 'package:domain/models/featured.dart';
import 'package:domain/models/news.dart';
import 'package:domain/use_cases/get_articles_from_api_use_case.dart';
import 'package:domain/use_cases/get_articles_stream_use_%20case.dart';
import 'package:domain/use_cases/get_articles_use_case.dart';
import 'package:domain/use_cases/get_featured_from_json_use_case.dart';
import 'package:domain/use_cases/get_news_from_json_use_case.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:lab_4/pages/article/article_controller.dart';
import 'package:lab_4/pages/article/article_page.dart';
import 'package:lab_4/resources/files.dart';

class HomeController extends GetxController{

  RxList<News> news = RxList();
  RxList<Featured> featured = RxList();

  RxList<Article> articleList = RxList();
  RxBool isLoading = false.obs;
  int page = 1;
  int limit = 5;
  bool canGetMoreData = true;

  var getArticlesUseCase = GetIt.instance.get<GetArticlesFromApiUseCase>();
  var getArticlesStream = GetIt.instance.get<GetArticlesStreamUseCase>();
  var getArticlesUC= GetIt.instance.get<GetArticlesUseCase>();
  var getFeatured = GetIt.instance.get<GetFeaturedFromJsonUseCase>();
  var getNews = GetIt.instance.get<GetNewsFromJsonUseCase>();


  void readJsonFile() async {
    news.value = await getNews(Files.news);
    featured.value = await getFeatured(Files.news);
  }

void getArticles() async {
    getArticlesUC.call(page, limit).then((articles) {
    // getArticlesUseCase.call(page, limit).then((articles) {
    // getArticlesStream.call(page, limit).listen((articles) {

        canGetMoreData = true;
        if (articles.length == articleList.value.length) {
          canGetMoreData = false;
        }
        articleList.value = articles;
        page++;
    });
  }

  void getNextPage() {
    if (canGetMoreData) {
      canGetMoreData = false;
      getArticles();
    }
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

  void openArticle(Article article){
    ArticleController aController = Get.find();
    aController.article = article;
    Get.to(ArticlePage());
  }

}