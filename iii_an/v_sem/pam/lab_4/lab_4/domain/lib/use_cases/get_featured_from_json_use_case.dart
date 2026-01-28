import 'package:domain/models/featured.dart';
import 'package:domain/repositories/news_repository.dart';

class GetFeaturedFromJsonUseCase {
  final NewsRepository repository;

  GetFeaturedFromJsonUseCase (this.repository);

  @override
  Future<List<Featured>> call(String filePath) {
    return repository.getFeaturedJson(filePath);
  }
}
