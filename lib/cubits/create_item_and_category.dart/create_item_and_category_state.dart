import 'dart:io';

import 'package:ct_shopping_list_challenge/models/category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SelectedForm { addCategory, addItem }

abstract class CreateItemAndCategoryViewState extends Equatable {}

class InitialState extends CreateItemAndCategoryViewState {
  @override
  List<Object> get props => [];
}

class LoadingState extends CreateItemAndCategoryViewState {
  @override
  List<Object> get props => [];
}

class LoadedState extends CreateItemAndCategoryViewState {

  LoadedState({
    required this.selectedForm, 
    required this.categories, 
    required this.imageFile,
    required this.selectedColor,
    required this.nameController,
    required this.categoryController,
    required this.categoryNameController,
  });

  final SelectedForm selectedForm;
  final List<Category> categories;
  final File? imageFile;
  final Color selectedColor;
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController categoryNameController;

  LoadedState copyWith({
    SelectedForm? selectedForm,
    List<Category>? categories,
    File? imageFile,
    Color? selectedColor,
  }) => LoadedState(
    selectedForm: selectedForm ?? this.selectedForm,
    categories: categories ?? this.categories,
    imageFile: imageFile ?? this.imageFile,
    selectedColor: selectedColor ?? this.selectedColor,
    nameController: nameController,
    categoryController: categoryController,
    categoryNameController: categoryNameController,
  );

  @override
  List<Object?> get props => [categories, imageFile, selectedForm, selectedColor];
}

class SuccesState extends CreateItemAndCategoryViewState {
  @override
  List<Object> get props => [];
}

class EmptyState extends CreateItemAndCategoryViewState {
  @override
  List<Object> get props => [];
}

class ErrorState extends CreateItemAndCategoryViewState {
  @override
  List<Object> get props => [];
}
