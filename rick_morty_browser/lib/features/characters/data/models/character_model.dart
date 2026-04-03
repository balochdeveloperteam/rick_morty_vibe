import 'dart:convert';

import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';

class CharacterModel {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.type,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String? type;

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      species: json['species'] as String? ?? '',
      image: json['image'] as String? ?? '',
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'type': type,
    };
  }

  factory CharacterModel.fromEntity(Character entity) {
    return CharacterModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      species: entity.species,
      image: entity.image,
      type: entity.type,
    );
  }

  Character toEntity({bool isFavorite = false}) {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
      type: type,
      isFavorite: isFavorite,
    );
  }

  static String encodeList(List<CharacterModel> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }

  static List<CharacterModel> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => CharacterModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
