import 'package:domain/models/article.dart';
import 'package:domain/repositories/article_repository.dart';

class GetArticlesStreamUseCase {

  final ArticleRepository repository;

  GetArticlesStreamUseCase(this.repository);

  Stream<List<Article>> call(int page, int limit) async * {
    repository.getArticlesApi(page, limit).then((value) {
      print(value);
      repository.insertArticlesDb(value);
    });
    yield* repository.getArticlesStream();
  }
}