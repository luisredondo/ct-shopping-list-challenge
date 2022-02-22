import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_shopping_list_challenge/models/item.dart';
import 'package:flutter/material.dart';

class Category {

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.items,
  });

  final String id;
  final String name;
  final Color color;
  final List<Item> items;

  factory Category.fromDocumentSnapshot(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] as String? ?? "",
      color: (data['color'] as String?)?.toColor() ?? Colors.white,
      items: [],
    );
  }

  Category copyWith({
    String? id,
    String? name,
    Color? color,
    List<Item>? items,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "color": color.toHex(),
    };
  }

}

extension ColorExtension on String {
  Color? toColor() {
    // ignore: unnecessary_this
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex() => "#${value.toRadixString(16)}";
}
