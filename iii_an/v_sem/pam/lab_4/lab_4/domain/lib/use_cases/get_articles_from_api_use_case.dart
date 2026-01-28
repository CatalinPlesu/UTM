import 'package:domain/models/article.dart';
import 'package:domain/repositories/article_repository.dart';

class GetArticlesFromApiUseCase {

  final ArticleRepository repository;

  GetArticlesFromApiUseCase(this.repository);

  @override
  Future<List<Article>> call(int page, int per_page) {
    return repository.getArticlesApi(page, per_page);
  }
}