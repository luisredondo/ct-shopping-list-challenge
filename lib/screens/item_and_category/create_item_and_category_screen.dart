import 'package:ct_shopping_list_challenge/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';
import 'package:ct_shopping_list_challenge/widgets/core/my_text_form_field.dart';

import 'package:ct_shopping_list_challenge/cubits/create_item_and_category.dart/create_item_and_category_cubit.dart';
import 'package:ct_shopping_list_challenge/cubits/create_item_and_category.dart/create_item_and_category_state.dart';
import 'package:ct_shopping_list_challenge/models/category.dart';

class CreateItemAndCategoryScreen extends StatelessWidget {
  const CreateItemAndCategoryScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateItemAndCategoryCubit()..loadCategories(),
      child: CreateItemAndCategoryView(),
    );
  }
}

class CreateItemAndCategoryView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBarTitle: "Create Item and Category",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<CreateItemAndCategoryCubit, CreateItemAndCategoryViewState>(
          listener: (context, state) {
            if (state is SuccesState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Item added!'),
              ),);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is LoadedState) {
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Add Category"),
                      Switch(
                        value: state.selectedForm == SelectedForm.addItem, 
                        onChanged: (val) => context.read<CreateItemAndCategoryCubit>().toggleForm(val),
                      ),
                      const Text("Add Item"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (state.selectedForm == SelectedForm.addCategory) ...[
                    AddCategoryForm(),
                  ] else ...[
                    AddItemForm(),
                  ]
                ],
              );
            } else if (state is ErrorState) {
              return const Center(child: Text("Error"),);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

}

class AddItemForm extends StatelessWidget {
  AddItemForm({ Key? key }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateItemAndCategoryCubit, CreateItemAndCategoryViewState>(
      builder: (context, state) {
        state as LoadedState;
        // TODO ADD FORM VALIDATION
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Add Item", style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 20),
              MyTextFormField(
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter some text';
                  }
                  final List<Item> items = state.categories.expand((c) => c.items).toList();
                  final List<Item> itemsWithSameName = items.where((item) => item.name == value).toList();
                  print("ITEMS, $items");
                  print("ITEMS with same name, $itemsWithSameName");
                  if (itemsWithSameName.isNotEmpty) {
                    return 'Item name already exists';
                  }
                  return null;
                },
                controller: state.nameController,
                inputPlaceholder: "Name",
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showCategoryPicker(context, 
                  selectedCategory: "",
                  categories: state.categories,
                  onClose: (selectedCategory) => context.read<CreateItemAndCategoryCubit>().updateSelectedCategory(selectedCategory),
                ),
                child: MyTextFormField(
                  controller: state.categoryController,
                  inputPlaceholder: state.categoryController.text.isEmpty ? "Category" : state.categoryController.text,
                  enabled: false,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => context.read<CreateItemAndCategoryCubit>().pickImage(state), 
                        child: const Text("Pick Image"),
                      ),
                    ),
                  ),
                  if (state.imageFile != null) ...[
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (state.imageFile == null) return;
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return Dialog(
                                  child: Image.file(state.imageFile!),
                                );
                              },
                            );
                          }, 
                          child: const Text("See Image"),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid ?? false) {
                    context.read<CreateItemAndCategoryCubit>().addItem();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCategoryPicker(BuildContext context, {
    required String? selectedCategory,
    required List<Category> categories,
    required Function(Category category) onClose,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    late Category _selectedCategory;
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: 300,
        height: 250,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 30,
          scrollController: FixedExtentScrollController(initialItem: 1),
          children: categories.map((category) => Text(category.name)).toList(),
          onSelectedItemChanged: (i) => _selectedCategory = categories[i],
        ),
      ),
    );
    onClose(_selectedCategory);
  }

}

class AddCategoryForm extends StatelessWidget {
  AddCategoryForm({ Key? key }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final List<Color> colorOptions = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateItemAndCategoryCubit, CreateItemAndCategoryViewState>(
      builder: (context, state) {
        state as LoadedState;
        // TODO ADD FORM VALIDATION
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Add Category", style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 20),
              MyTextFormField(
                controller: state.categoryNameController,
                inputPlaceholder: "Name",
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter some text';
                  }
                  final List<Category> categoriesWithSameName = state.categories.where((category) => category.name == value).toList();
                  if (categoriesWithSameName.isNotEmpty) {
                    return 'Category already exists';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: colorOptions.map((color) => GestureDetector(
                    onTap: () => context.read<CreateItemAndCategoryCubit>().updateSelectedColor(color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        border: state.selectedColor == color ? Border.all(width: 2) : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ).toList(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid ?? false) {
                    context.read<CreateItemAndCategoryCubit>().addCategory();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }

}
