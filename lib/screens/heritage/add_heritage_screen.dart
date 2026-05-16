import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/heritage_provider.dart';
import '../../models/heritage_item.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_widget.dart';

class AddHeritageScreen extends StatefulWidget {
  const AddHeritageScreen({super.key});

  @override
  State<AddHeritageScreen> createState() => _AddHeritageScreenState();
}

class _AddHeritageScreenState extends State<AddHeritageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HeritageProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Heritage')),
          body: provider.isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: 'Title',
                          validator: (v) => Validators.validateRequired(v, 'Title'),
                        ),
                        CustomTextField(
                          controller: _countryController,
                          label: 'Country / Region',
                          validator: (v) => Validators.validateRequired(v, 'Country'),
                        ),
                        CustomTextField(
                          controller: _categoryController,
                          label: 'Category',
                          validator: (v) => Validators.validateRequired(v, 'Category'),
                        ),
                        CustomTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          maxLines: 3,
                          validator: (v) => Validators.validateRequired(v, 'Description'),
                        ),
                        CustomTextField(
                          controller: _imageUrlController,
                          label: 'Image URL',
                          validator: Validators.validateUrl,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            final newItem = HeritageItem(
                              id: 0.toString(), // will be replaced by API
                              title: _nameController.text.trim(),
                              name: _nameController.text.trim(),
                              country: _countryController.text.trim(),
                              category: _categoryController.text.trim(),
                              description: _descriptionController.text.trim(),
                              imageUrl: _imageUrlController.text.trim().isEmpty
                                  ? null
                                  : _imageUrlController.text.trim(),
                            );
                            final success = await provider.addItem(newItem);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(success ? 'Item added' : 'Failed to add item')),
                              );
                              if (success) Navigator.pop(context);
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}