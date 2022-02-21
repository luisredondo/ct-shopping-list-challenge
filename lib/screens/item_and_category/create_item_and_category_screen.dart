import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/widgets/core/my_scaffold.dart';
import 'package:ct_shopping_list_challenge/widgets/core/my_text_form_field.dart';
import 'package:image_picker/image_picker.dart';

class CreateItemAndCategoryScreen extends StatefulWidget {
  const CreateItemAndCategoryScreen({ Key? key }) : super(key: key);

  @override
  State<CreateItemAndCategoryScreen> createState() => _CreateItemAndCategoryScreenState();
}

class _CreateItemAndCategoryScreenState extends State<CreateItemAndCategoryScreen> {

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBarTitle: "Create Item and Category",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Add Category"),
                  Switch(value: true, onChanged: (_) {}),
                  const Text("Add Item"),
                ],
              ),
              const SizedBox(height: 20),
              Text("Add Item", style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 20),
              const MyTextFormField(
                inputPlaceholder: "Name",
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showPicker(context),
                child: const MyTextFormField(
                  inputPlaceholder: "Category",
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
                        onPressed: () async {
                          final ip = ImagePicker();
                          final XFile? file = await ip.pickImage(source: ImageSource.gallery);
                          if (file != null) {
                            setState(() => imageFile = File(file.path));
                          }
                        }, 
                        child: const Text("Pick Image"),
                      ),
                    ),
                  ),
                  if (imageFile != null) ...[
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return Dialog(
                                  child: Image.file(imageFile!),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => SizedBox(
        width: 300,
        height: 250,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 30,
          scrollController: FixedExtentScrollController(initialItem: 1),
          children: const <Widget>[
            Text('0'),
            Text('1'),
            Text('2'),
          ],
          onSelectedItemChanged: (value) {
            // setState(() {
            //   _selectedValue = value;
            // });
          },
        ),
      ),
    );
  }
}
