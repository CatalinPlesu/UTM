import 'package:domain/models/article.dart';
import 'package:domain/repositories/article_repository.dart';

class GetArticlesUseCase {

  final ArticleRepository repository;

  GetArticlesUseCase(this.repository);

  Future<List<Article>> call(int page, int limit) async {
    repository.getArticlesApi(page, limit).then((value) {
      print(value);
      repository.insertArticlesDb(value);
    });
    return repository.getArticles();
  }
}
