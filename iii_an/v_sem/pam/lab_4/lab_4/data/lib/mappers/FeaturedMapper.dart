import 'package:data/entities/json/featured_json_dto.dart';
import 'package:domain/models/featured.dart';

class FeaturedMapper {

  Featured mapJsonDtoToModel(FeaturedJsonDto featured){
    return Featured(featured.cover, featured.title);
  }
}
