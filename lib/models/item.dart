import 'package:cloud_firestore/cloud_firestore.dart';

class Item {

  const Item({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imageUrl,
    required this.isFavorite,
    required this.addedToFavoritesAt,
  });

  final String id;
  final String categoryId;
  final String name;
  final String imageUrl;
  final bool isFavorite;
  final DateTime? addedToFavoritesAt;

  factory Item.fromDocumentSnapshot(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Item(
      id: doc.id,
      categoryId: data['category_id'] as String,
      name: data['name'] as String? ?? "",
      imageUrl: data['image_url'] as String? ?? "",
      isFavorite: data['is_favorite'] as bool? ?? false,
      addedToFavoritesAt: (data['added_to_favorites_at'] as Timestamp?)?.toDate(),
    );
  }

  Item copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? imageUrl,
    bool? isFavorite,
    DateTime? addedToFavoritesAt,
  }) {
    return Item(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      addedToFavoritesAt: addedToFavoritesAt ?? this.addedToFavoritesAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
      'added_to_favorites_at': addedToFavoritesAt,
    };
  }

}
