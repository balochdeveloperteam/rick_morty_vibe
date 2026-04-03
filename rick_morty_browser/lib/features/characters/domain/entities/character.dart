import 'package:equatable/equatable.dart';

class Character extends Equatable {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.type,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String? type;
  final bool isFavorite;

  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? image,
    String? type,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, name, status, species, image, type, isFavorite];
}
