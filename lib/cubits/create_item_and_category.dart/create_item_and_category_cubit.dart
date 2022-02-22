import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ct_shopping_list_challenge/config/config.locator.dart';
import 'package:ct_shopping_list_challenge/cubits/create_item_and_category.dart/create_item_and_category_state.dart';
import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:ct_shopping_list_challenge/models/item.dart';
import 'package:ct_shopping_list_challenge/services/database_service.dart';
// import 'package:ct_shopping_list_challenge/services/file_storage_service.dart';

class CreateItemAndCategoryCubit extends Cubit<CreateItemAndCategoryViewState> {

  CreateItemAndCategoryCubit() : super(InitialState());

  final _databaseService = locator<DatabaseService>();
  // final _fileStorageService = locator<FileStorageService>();
  final imagePicker = ImagePicker();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final categoryNameController = TextEditingController();
  Category? _selectedCategory;

  Category? get selectedCategory => _selectedCategory;

  void loadCategories() {
    emit(LoadingState());
    bool isFirstTime = true;
    _databaseService.streamFilledCategories().listen((categories) { 
      if (categories.isNotEmpty) {
        if (isFirstTime) {
          emit(LoadedState(
            selectedForm: SelectedForm.addItem,
            categories: categories,
            imageFile: null,
            nameController: nameController,
            categoryController: categoryController,
            categoryNameController: categoryNameController,
            selectedColor: Colors.red,
          ),);
          isFirstTime = false;
        } else {
          emit((state as LoadedState).copyWith(categories: categories));
        }
      }
    });
  }

  // ignore: avoid_positional_boolean_parameters
  void toggleForm(bool isAddCategory) {
    final LoadedState loadedState = state as LoadedState;
    emit(LoadingState());
    emit(loadedState.copyWith(
      selectedForm: isAddCategory ? SelectedForm.addItem : SelectedForm.addCategory,
    ),);
  }

  // ignore: use_setters_to_change_properties
  void updateSelectedCategory(Category category) {
    (state as LoadedState).categoryController.text = category.name;
    _selectedCategory = category;
  }

  void updateSelectedColor(Color color) {
    emit((state as LoadedState).copyWith(
      selectedColor: color,
    ),);
  }

  Future<void> pickImage(LoadedState state) async {
    try {
      final XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null ) {
        emit(state.copyWith(
          imageFile: File(file.path),
        ),);
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> addItem() async {
    try {
      final previousState = state as LoadedState;
      // final imageUrl = await _fileStorageService.uploadImage(previousState.imageFile!);
      const imageUrl = "https://picsum.photos/200";
      await _databaseService.addItem(selectedCategory!, Item(
        id: _databaseService.generateDocId,
        name: previousState.nameController.text,
        categoryId: selectedCategory!.id,
        imageUrl: imageUrl,
        isFavorite: false,
        addedToFavoritesAt: null,
      ),).then((_) {
        emit(SuccesState());
        emit(previousState);
      });
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> addCategory() async {
    try {
      final previousState = state as LoadedState;
      emit(LoadingState());
      await _databaseService.addCategory(Category(
        id: _databaseService.generateDocId, 
        name: previousState.categoryNameController.text, 
        color: previousState.selectedColor,
        items: [],
      ),).then((_) {
        emit(previousState);
      });
    } catch (e) {
      emit(ErrorState());
    }
  }

}
