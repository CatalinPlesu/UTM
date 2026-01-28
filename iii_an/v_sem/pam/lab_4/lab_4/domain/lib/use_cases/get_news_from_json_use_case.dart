import 'package:domain/models/news.dart';
import 'package:domain/repositories/news_repository.dart';

class GetNewsFromJsonUseCase {
  final NewsRepository repository;

  GetNewsFromJsonUseCase (this.repository);

  @override
  Future<List<News>> call(String filePath) {
    return repository.getNewsJson(filePath);
  }
}