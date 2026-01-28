// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ArticlesTableData extends DataClass
    implements Insertable<ArticlesTableData> {
  final int id;
  final int author_id;
  final String author_modified_at;
  final String author_created_at;
  final String author_name;
  final String author_avatar;
  final int category_id;
  final String category_modified_at;
  final String category_created_at;
  final String category_title;
  final String tags;
  final String description;
  final String content;
  final String image;
  final int views_count;
  final bool is_featured;
  const ArticlesTableData(
      {required this.id,
      required this.author_id,
      required this.author_modified_at,
      required this.author_created_at,
      required this.author_name,
      required this.author_avatar,
      required this.category_id,
      required this.category_modified_at,
      required this.category_created_at,
      required this.category_title,
      required this.tags,
      required this.description,
      required this.content,
      required this.image,
      required this.views_count,
      required this.is_featured});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['author_id'] = Variable<int>(author_id);
    map['author_modified_at'] = Variable<String>(author_modified_at);
    map['author_created_at'] = Variable<String>(author_created_at);
    map['author_name'] = Variable<String>(author_name);
    map['author_avatar'] = Variable<String>(author_avatar);
    map['category_id'] = Variable<int>(category_id);
    map['category_modified_at'] = Variable<String>(category_modified_at);
    map['category_created_at'] = Variable<String>(category_created_at);
    map['category_title'] = Variable<String>(category_title);
    map['tags'] = Variable<String>(tags);
    map['description'] = Variable<String>(description);
    map['content'] = Variable<String>(content);
    map['image'] = Variable<String>(image);
    map['views_count'] = Variable<int>(views_count);
    map['is_featured'] = Variable<bool>(is_featured);
    return map;
  }

  ArticlesTableCompanion toCompanion(bool nullToAbsent) {
    return ArticlesTableCompanion(
      id: Value(id),
      author_id: Value(author_id),
      author_modified_at: Value(author_modified_at),
      author_created_at: Value(author_created_at),
      author_name: Value(author_name),
      author_avatar: Value(author_avatar),
      category_id: Value(category_id),
      category_modified_at: Value(category_modified_at),
      category_created_at: Value(category_created_at),
      category_title: Value(category_title),
      tags: Value(tags),
      description: Value(description),
      content: Value(content),
      image: Value(image),
      views_count: Value(views_count),
      is_featured: Value(is_featured),
    );
  }

  factory ArticlesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticlesTableData(
      id: serializer.fromJson<int>(json['id']),
      author_id: serializer.fromJson<int>(json['author_id']),
      author_modified_at:
          serializer.fromJson<String>(json['author_modified_at']),
      author_created_at: serializer.fromJson<String>(json['author_created_at']),
      author_name: serializer.fromJson<String>(json['author_name']),
      author_avatar: serializer.fromJson<String>(json['author_avatar']),
      category_id: serializer.fromJson<int>(json['category_id']),
      category_modified_at:
          serializer.fromJson<String>(json['category_modified_at']),
      category_created_at:
          serializer.fromJson<String>(json['category_created_at']),
      category_title: serializer.fromJson<String>(json['category_title']),
      tags: serializer.fromJson<String>(json['tags']),
      description: serializer.fromJson<String>(json['description']),
      content: serializer.fromJson<String>(json['content']),
      image: serializer.fromJson<String>(json['image']),
      views_count: serializer.fromJson<int>(json['views_count']),
      is_featured: serializer.fromJson<bool>(json['is_featured']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'author_id': serializer.toJson<int>(author_id),
      'author_modified_at': serializer.toJson<String>(author_modified_at),
      'author_created_at': serializer.toJson<String>(author_created_at),
      'author_name': serializer.toJson<String>(author_name),
      'author_avatar': serializer.toJson<String>(author_avatar),
      'category_id': serializer.toJson<int>(category_id),
      'category_modified_at': serializer.toJson<String>(category_modified_at),
      'category_created_at': serializer.toJson<String>(category_created_at),
      'category_title': serializer.toJson<String>(category_title),
      'tags': serializer.toJson<String>(tags),
      'description': serializer.toJson<String>(description),
      'content': serializer.toJson<String>(content),
      'image': serializer.toJson<String>(image),
      'views_count': serializer.toJson<int>(views_count),
      'is_featured': serializer.toJson<bool>(is_featured),
    };
  }

  ArticlesTableData copyWith(
          {int? id,
          int? author_id,
          String? author_modified_at,
          String? author_created_at,
          String? author_name,
          String? author_avatar,
          int? category_id,
          String? category_modified_at,
          String? category_created_at,
          String? category_title,
          String? tags,
          String? description,
          String? content,
          String? image,
          int? views_count,
          bool? is_featured}) =>
      ArticlesTableData(
        id: id ?? this.id,
        author_id: author_id ?? this.author_id,
        author_modified_at: author_modified_at ?? this.author_modified_at,
        author_created_at: author_created_at ?? this.author_created_at,
        author_name: author_name ?? this.author_name,
        author_avatar: author_avatar ?? this.author_avatar,
        category_id: category_id ?? this.category_id,
        category_modified_at: category_modified_at ?? this.category_modified_at,
        category_created_at: category_created_at ?? this.category_created_at,
        category_title: category_title ?? this.category_title,
        tags: tags ?? this.tags,
        description: description ?? this.description,
        content: content ?? this.content,
        image: image ?? this.image,
        views_count: views_count ?? this.views_count,
        is_featured: is_featured ?? this.is_featured,
      );
  @override
  String toString() {
    return (StringBuffer('ArticlesTableData(')
          ..write('id: $id, ')
          ..write('author_id: $author_id, ')
          ..write('author_modified_at: $author_modified_at, ')
          ..write('author_created_at: $author_created_at, ')
          ..write('author_name: $author_name, ')
          ..write('author_avatar: $author_avatar, ')
          ..write('category_id: $category_id, ')
          ..write('category_modified_at: $category_modified_at, ')
          ..write('category_created_at: $category_created_at, ')
          ..write('category_title: $category_title, ')
          ..write('tags: $tags, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('views_count: $views_count, ')
          ..write('is_featured: $is_featured')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      author_id,
      author_modified_at,
      author_created_at,
      author_name,
      author_avatar,
      category_id,
      category_modified_at,
      category_created_at,
      category_title,
      tags,
      description,
      content,
      image,
      views_count,
      is_featured);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticlesTableData &&
          other.id == this.id &&
          other.author_id == this.author_id &&
          other.author_modified_at == this.author_modified_at &&
          other.author_created_at == this.author_created_at &&
          other.author_name == this.author_name &&
          other.author_avatar == this.author_avatar &&
          other.category_id == this.category_id &&
          other.category_modified_at == this.category_modified_at &&
          other.category_created_at == this.category_created_at &&
          other.category_title == this.category_title &&
          other.tags == this.tags &&
          other.description == this.description &&
          other.content == this.content &&
          other.image == this.image &&
          other.views_count == this.views_count &&
          other.is_featured == this.is_featured);
}

class ArticlesTableCompanion extends UpdateCompanion<ArticlesTableData> {
  final Value<int> id;
  final Value<int> author_id;
  final Value<String> author_modified_at;
  final Value<String> author_created_at;
  final Value<String> author_name;
  final Value<String> author_avatar;
  final Value<int> category_id;
  final Value<String> category_modified_at;
  final Value<String> category_created_at;
  final Value<String> category_title;
  final Value<String> tags;
  final Value<String> description;
  final Value<String> content;
  final Value<String> image;
  final Value<int> views_count;
  final Value<bool> is_featured;
  const ArticlesTableCompanion({
    this.id = const Value.absent(),
    this.author_id = const Value.absent(),
    this.author_modified_at = const Value.absent(),
    this.author_created_at = const Value.absent(),
    this.author_name = const Value.absent(),
    this.author_avatar = const Value.absent(),
    this.category_id = const Value.absent(),
    this.category_modified_at = const Value.absent(),
    this.category_created_at = const Value.absent(),
    this.category_title = const Value.absent(),
    this.tags = const Value.absent(),
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.image = const Value.absent(),
    this.views_count = const Value.absent(),
    this.is_featured = const Value.absent(),
  });
  ArticlesTableCompanion.insert({
    this.id = const Value.absent(),
    required int author_id,
    required String author_modified_at,
    required String author_created_at,
    required String author_name,
    required String author_avatar,
    required int category_id,
    required String category_modified_at,
    required String category_created_at,
    required String category_title,
    required String tags,
    required String description,
    required String content,
    required String image,
    required int views_count,
    required bool is_featured,
  })  : author_id = Value(author_id),
        author_modified_at = Value(author_modified_at),
        author_created_at = Value(author_created_at),
        author_name = Value(author_name),
        author_avatar = Value(author_avatar),
        category_id = Value(category_id),
        category_modified_at = Value(category_modified_at),
        category_created_at = Value(category_created_at),
        category_title = Value(category_title),
        tags = Value(tags),
        description = Value(description),
        content = Value(content),
        image = Value(image),
        views_count = Value(views_count),
        is_featured = Value(is_featured);
  static Insertable<ArticlesTableData> custom({
    Expression<int>? id,
    Expression<int>? author_id,
    Expression<String>? author_modified_at,
    Expression<String>? author_created_at,
    Expression<String>? author_name,
    Expression<String>? author_avatar,
    Expression<int>? category_id,
    Expression<String>? category_modified_at,
    Expression<String>? category_created_at,
    Expression<String>? category_title,
    Expression<String>? tags,
    Expression<String>? description,
    Expression<String>? content,
    Expression<String>? image,
    Expression<int>? views_count,
    Expression<bool>? is_featured,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (author_id != null) 'author_id': author_id,
      if (author_modified_at != null) 'author_modified_at': author_modified_at,
      if (author_created_at != null) 'author_created_at': author_created_at,
      if (author_name != null) 'author_name': author_name,
      if (author_avatar != null) 'author_avatar': author_avatar,
      if (category_id != null) 'category_id': category_id,
      if (category_modified_at != null)
        'category_modified_at': category_modified_at,
      if (category_created_at != null)
        'category_created_at': category_created_at,
      if (category_title != null) 'category_title': category_title,
      if (tags != null) 'tags': tags,
      if (description != null) 'description': description,
      if (content != null) 'content': content,
      if (image != null) 'image': image,
      if (views_count != null) 'views_count': views_count,
      if (is_featured != null) 'is_featured': is_featured,
    });
  }

  ArticlesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? author_id,
      Value<String>? author_modified_at,
      Value<String>? author_created_at,
      Value<String>? author_name,
      Value<String>? author_avatar,
      Value<int>? category_id,
      Value<String>? category_modified_at,
      Value<String>? category_created_at,
      Value<String>? category_title,
      Value<String>? tags,
      Value<String>? description,
      Value<String>? content,
      Value<String>? image,
      Value<int>? views_count,
      Value<bool>? is_featured}) {
    return ArticlesTableCompanion(
      id: id ?? this.id,
      author_id: author_id ?? this.author_id,
      author_modified_at: author_modified_at ?? this.author_modified_at,
      author_created_at: author_created_at ?? this.author_created_at,
      author_name: author_name ?? this.author_name,
      author_avatar: author_avatar ?? this.author_avatar,
      category_id: category_id ?? this.category_id,
      category_modified_at: category_modified_at ?? this.category_modified_at,
      category_created_at: category_created_at ?? this.category_created_at,
      category_title: category_title ?? this.category_title,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      content: content ?? this.content,
      image: image ?? this.image,
      views_count: views_count ?? this.views_count,
      is_featured: is_featured ?? this.is_featured,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (author_id.present) {
      map['author_id'] = Variable<int>(author_id.value);
    }
    if (author_modified_at.present) {
      map['author_modified_at'] = Variable<String>(author_modified_at.value);
    }
    if (author_created_at.present) {
      map['author_created_at'] = Variable<String>(author_created_at.value);
    }
    if (author_name.present) {
      map['author_name'] = Variable<String>(author_name.value);
    }
    if (author_avatar.present) {
      map['author_avatar'] = Variable<String>(author_avatar.value);
    }
    if (category_id.present) {
      map['category_id'] = Variable<int>(category_id.value);
    }
    if (category_modified_at.present) {
      map['category_modified_at'] =
          Variable<String>(category_modified_at.value);
    }
    if (category_created_at.present) {
      map['category_created_at'] = Variable<String>(category_created_at.value);
    }
    if (category_title.present) {
      map['category_title'] = Variable<String>(category_title.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (views_count.present) {
      map['views_count'] = Variable<int>(views_count.value);
    }
    if (is_featured.present) {
      map['is_featured'] = Variable<bool>(is_featured.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesTableCompanion(')
          ..write('id: $id, ')
          ..write('author_id: $author_id, ')
          ..write('author_modified_at: $author_modified_at, ')
          ..write('author_created_at: $author_created_at, ')
          ..write('author_name: $author_name, ')
          ..write('author_avatar: $author_avatar, ')
          ..write('category_id: $category_id, ')
          ..write('category_modified_at: $category_modified_at, ')
          ..write('category_created_at: $category_created_at, ')
          ..write('category_title: $category_title, ')
          ..write('tags: $tags, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('image: $image, ')
          ..write('views_count: $views_count, ')
          ..write('is_featured: $is_featured')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTableTable extends ArticlesTable
    with TableInfo<$ArticlesTableTable, ArticlesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _author_idMeta = const VerificationMeta('author_id');
  @override
  late final GeneratedColumn<int> author_id = GeneratedColumn<int>(
      'author_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _author_modified_atMeta =
      const VerificationMeta('author_modified_at');
  @override
  late final GeneratedColumn<String> author_modified_at =
      GeneratedColumn<String>('author_modified_at', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _author_created_atMeta =
      const VerificationMeta('author_created_at');
  @override
  late final GeneratedColumn<String> author_created_at =
      GeneratedColumn<String>('author_created_at', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _author_nameMeta =
      const VerificationMeta('author_name');
  @override
  late final GeneratedColumn<String> author_name = GeneratedColumn<String>(
      'author_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _author_avatarMeta =
      const VerificationMeta('author_avatar');
  @override
  late final GeneratedColumn<String> author_avatar = GeneratedColumn<String>(
      'author_avatar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _category_idMeta =
      const VerificationMeta('category_id');
  @override
  late final GeneratedColumn<int> category_id = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _category_modified_atMeta =
      const VerificationMeta('category_modified_at');
  @override
  late final GeneratedColumn<String> category_modified_at =
      GeneratedColumn<String>('category_modified_at', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _category_created_atMeta =
      const VerificationMeta('category_created_at');
  @override
  late final GeneratedColumn<String> category_created_at =
      GeneratedColumn<String>('category_created_at', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _category_titleMeta =
      const VerificationMeta('category_title');
  @override
  late final GeneratedColumn<String> category_title = GeneratedColumn<String>(
      'category_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _views_countMeta =
      const VerificationMeta('views_count');
  @override
  late final GeneratedColumn<int> views_count = GeneratedColumn<int>(
      'views_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _is_featuredMeta =
      const VerificationMeta('is_featured');
  @override
  late final GeneratedColumn<bool> is_featured = GeneratedColumn<bool>(
      'is_featured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK ("is_featured" IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        author_id,
        author_modified_at,
        author_created_at,
        author_name,
        author_avatar,
        category_id,
        category_modified_at,
        category_created_at,
        category_title,
        tags,
        description,
        content,
        image,
        views_count,
        is_featured
      ];
  @override
  String get aliasedName => _alias ?? 'articles_table';
  @override
  String get actualTableName => 'articles_table';
  @override
  VerificationContext validateIntegrity(Insertable<ArticlesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('author_id')) {
      context.handle(_author_idMeta,
          author_id.isAcceptableOrUnknown(data['author_id']!, _author_idMeta));
    } else if (isInserting) {
      context.missing(_author_idMeta);
    }
    if (data.containsKey('author_modified_at')) {
      context.handle(
          _author_modified_atMeta,
          author_modified_at.isAcceptableOrUnknown(
              data['author_modified_at']!, _author_modified_atMeta));
    } else if (isInserting) {
      context.missing(_author_modified_atMeta);
    }
    if (data.containsKey('author_created_at')) {
      context.handle(
          _author_created_atMeta,
          author_created_at.isAcceptableOrUnknown(
              data['author_created_at']!, _author_created_atMeta));
    } else if (isInserting) {
      context.missing(_author_created_atMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _author_nameMeta,
          author_name.isAcceptableOrUnknown(
              data['author_name']!, _author_nameMeta));
    } else if (isInserting) {
      context.missing(_author_nameMeta);
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
          _author_avatarMeta,
          author_avatar.isAcceptableOrUnknown(
              data['author_avatar']!, _author_avatarMeta));
    } else if (isInserting) {
      context.missing(_author_avatarMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _category_idMeta,
          category_id.isAcceptableOrUnknown(
              data['category_id']!, _category_idMeta));
    } else if (isInserting) {
      context.missing(_category_idMeta);
    }
    if (data.containsKey('category_modified_at')) {
      context.handle(
          _category_modified_atMeta,
          category_modified_at.isAcceptableOrUnknown(
              data['category_modified_at']!, _category_modified_atMeta));
    } else if (isInserting) {
      context.missing(_category_modified_atMeta);
    }
    if (data.containsKey('category_created_at')) {
      context.handle(
          _category_created_atMeta,
          category_created_at.isAcceptableOrUnknown(
              data['category_created_at']!, _category_created_atMeta));
    } else if (isInserting) {
      context.missing(_category_created_atMeta);
    }
    if (data.containsKey('category_title')) {
      context.handle(
          _category_titleMeta,
          category_title.isAcceptableOrUnknown(
              data['category_title']!, _category_titleMeta));
    } else if (isInserting) {
      context.missing(_category_titleMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('views_count')) {
      context.handle(
          _views_countMeta,
          views_count.isAcceptableOrUnknown(
              data['views_count']!, _views_countMeta));
    } else if (isInserting) {
      context.missing(_views_countMeta);
    }
    if (data.containsKey('is_featured')) {
      context.handle(
          _is_featuredMeta,
          is_featured.isAcceptableOrUnknown(
              data['is_featured']!, _is_featuredMeta));
    } else if (isInserting) {
      context.missing(_is_featuredMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArticlesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticlesTableData(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      author_id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}author_id'])!,
      author_modified_at: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}author_modified_at'])!,
      author_created_at: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}author_created_at'])!,
      author_name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}author_name'])!,
      author_avatar: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}author_avatar'])!,
      category_id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      category_modified_at: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}category_modified_at'])!,
      category_created_at: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}category_created_at'])!,
      category_title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}category_title'])!,
      tags: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      description: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      content: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      image: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      views_count: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}views_count'])!,
      is_featured: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}is_featured'])!,
    );
  }

  @override
  $ArticlesTableTable createAlias(String alias) {
    return $ArticlesTableTable(attachedDatabase, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $ArticlesTableTable articlesTable = $ArticlesTableTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [articlesTable];
}
