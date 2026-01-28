class Author{
  int id;
  String modified_at;
  String created_at;
  String name;
  String avatar;

  Author(this.id, this.modified_at, this.created_at, this.name, this.avatar);
}

class Category{
  int id;
  String modified_at;
  String created_at;
  String title;
  Category(this.id, this.modified_at, this.created_at, this.title);
}

class Article{
  int id;
  Author author;
  Category category;
  List<String> tags;
  String description;
  String content;
  String image;
  int views_count;
  int likes_count;
  int comments_count;
  bool is_featured;
  Article(this.id, this.author, this.category, this.tags, this.description, this.content, this.image, this.views_count, this.likes_count, this.comments_count, this.is_featured);
}
