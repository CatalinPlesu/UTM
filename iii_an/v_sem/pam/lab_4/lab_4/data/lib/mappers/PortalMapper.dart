import 'package:data/entities/json/portal_json_dto.dart';
import 'package:domain/models/portal.dart';

class PortalMapper {

  Portal mapJsonDtoToModel(PortalJsonDto portal){
    return Portal(portal.title, portal.logo);
  }
}
