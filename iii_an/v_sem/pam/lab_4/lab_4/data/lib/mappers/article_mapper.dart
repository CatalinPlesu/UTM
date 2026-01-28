import 'package:data/database/database.dart';
import 'package:data/entities/api/article_api_dto.dart';
import 'package:domain/models/article.dart';
import 'dart:math';

class ArticleMapper {
  Random random = new Random();

  Article mapApiDtoToModel(ArticleApiDto article){
    return Article(article.id,
        Author(article.author.id, article.author.modified_at, article.author.created_at, article.author.name, article.author.avatar),
        Category(article.category.id, article.category.modified_at, article.category.created_at, article.category.title),
        article.tags, article.description, article.content, article.image, article.views_count,
        random.nextInt(article.views_count), random.nextInt(article.views_count * 3), // valori random pentru likes si comments
        article.is_featured);
  }


  Article mapDbToModel(ArticlesTableData article){
    return Article(article.id,
        Author(article.author_id, article.author_modified_at, article.author_created_at, article.author_name, article.author_avatar),
        Category(article.category_id, article.category_modified_at, article.category_created_at, article.category_title),
        article.tags.split(','), article.description, article.content, article.image, article.views_count,
        random.nextInt(article.views_count), random.nextInt(article.views_count * 3), // valori random pentru likes si comments
        article.is_featured);
  }
  ArticlesTableData mapModelToDb(Article article){
    return ArticlesTableData(id: article.id, author_id: article.author.id, author_modified_at: article.author.modified_at, author_created_at: article.author.created_at, author_name: article.author.name, author_avatar: article.author.avatar, category_id: article.category.id, category_modified_at: article.category.modified_at, category_created_at: article.category.created_at, category_title: article.category.title,
        tags: article.tags.reduce((value, element) => value + ',' + element),
        description: article.description, content: article.content, image: article.image, views_count: article.views_count, is_featured: article.is_featured);
  }
}
