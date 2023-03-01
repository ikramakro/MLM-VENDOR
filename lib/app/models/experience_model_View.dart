import 'dart:core';

import 'media_model.dart';
import 'parents/model.dart';

class ExperienceView extends Model {
  String id;
  String title;
  String description;
  List<Media> images;

  // Media images = new Media();

  ExperienceView({this.id, this.title, this.description, this.images});

  ExperienceView.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = transStringFromJson(json, 'title');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'media');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';
}
