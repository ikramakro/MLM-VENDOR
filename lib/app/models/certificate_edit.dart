import 'parents/model.dart';

class CertificateEdit extends Model {
  String desc;
  String title;
  String e_provider_id;

  CertificateEdit({
    this.desc,
    this.title,
    this.e_provider_id,
  });

  // PortfolioAlbum.fromJson(Map<String, dynamic> json) {
  //   super.fromJson(json);
  //   name = transStringFromJson(json, 'name');
  //   color = colorFromJson(json, 'color');
  //   description = transStringFromJson(json, 'description');
  //   image = mediaFromJson(json, 'image');
  //   featured = boolFromJson(json, 'featured');
  //   eServices = listFromJsonArray(json, ['e_services', 'featured_e_services'],
  //       (v) => EService.fromJson(v));
  //   subCategories =
  //       listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['description'] = this.desc;
    data['title'] = this.title;
    data['e_provider_id'] = this.e_provider_id;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CertificateEdit &&
          runtimeType == other.runtimeType &&
          desc == other.desc &&
          title == other.title &&
          e_provider_id == other.e_provider_id;

  @override
  int get hashCode =>
      super.hashCode ^ desc.hashCode ^ title.hashCode ^ e_provider_id.hashCode;
}
