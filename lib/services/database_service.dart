import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:ct_shopping_list_challenge/models/item.dart';

class DatabaseServiceException implements Exception {}

class StreamingError implements DatabaseServiceException {
  final String message;
  StreamingError(this.message);
}

class AdditionError implements DatabaseServiceException {
  final String message;
  AdditionError(this.message);
}

class EliminationError implements DatabaseServiceException {
  final String message;
  EliminationError(this.message);
}

class DatabaseService {

  final CollectionReference _categoriesCollection = FirebaseFirestore.instance.collection('categories');

  String get generateDocId => _categoriesCollection.doc().id;

  Stream<List<Category>> streamFilledCategories() async* {
    try {
      final StreamController<List<Category>> streamController = StreamController();

      final Stream<List<Category>> categoriesStream = _categoriesCollection
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Category.fromDocumentSnapshot(doc)).toList());

      final Stream<List<Item>> itemsStream = FirebaseFirestore.instance
        .collectionGroup("items")
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Item.fromDocumentSnapshot(doc)).toList());

      categoriesStream.listen((categories) { 
        itemsStream.listen((items) {
          final List<Category> _categories = [];
          for (final category in categories) {
            final itemsByCategory = items.where((it) => it.categoryId == category.id).toList();
            _categories.add(category.copyWith(items: itemsByCategory));
            streamController.add(_categories);
          }
        });
      });

      yield* streamController.stream;
    } catch (e) {
      throw StreamingError(e.toString());
    }
  }

  Stream<List<Category>> streamCategories() {
    try {
      return _categoriesCollection
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Category.fromDocumentSnapshot(doc)).toList());
    } catch (e) {
      throw StreamingError(e.toString());
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _categoriesCollection.add(category.toJson());
    } catch (e) {
      throw AdditionError(e.toString());
    }
  }

  Future<void> deleteCategory(Category category) async {
    try {
      await _categoriesCollection.doc(category.id).delete();
    } catch (e) {
      throw EliminationError(e.toString());
    }
  }

  Future<void> addItem(Category category, Item item) async {
    try {
      await _categoriesCollection
        .doc(category.id)
        .collection("items")
        .add(item.toJson());
    } catch (e) {
      throw AdditionError(e.toString());
    }
  }

  Future<void> deleteItem(Category category, Item item) async {
    try {
      await _categoriesCollection
        .doc(category.id)
        .collection("items")
        .doc(item.id)
        .delete();
    } catch (e) {
      throw EliminationError(e.toString());
    }
  }

  Future<void> updateItem(Category category, Item item) async {
    try {
      await _categoriesCollection
        .doc(category.id)
        .collection("items")
        .doc(item.id)
        .set(item.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw AdditionError(e.toString());
    }
  }

}
