import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/heritage_provider.dart';
import '../../models/heritage_item.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_widget.dart';

class EditHeritageScreen extends StatefulWidget {
  final String itemId;
  const EditHeritageScreen({super.key, required this.itemId});

  @override
  State<EditHeritageScreen> createState() => _EditHeritageScreenState();
}

class _EditHeritageScreenState extends State<EditHeritageScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _countryController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  HeritageItem? _item;

  @override
  void initState() {
    super.initState();
    final provider = context.read<HeritageProvider>();
    _item = provider.getItemById(widget.itemId);
    _nameController = TextEditingController(text: _item?.name ?? '');
    _countryController = TextEditingController(text: _item?.country ?? '');
    _categoryController = TextEditingController(text: _item?.category ?? '');
    _descriptionController = TextEditingController(text: _item?.description ?? '');
    _imageUrlController = TextEditingController(text: _item?.imageUrl ?? '');
  }

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
          appBar: AppBar(title: const Text('Edit Heritage')),
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
                            final updatedItem = _item!.copyWith(
                              name: _nameController.text.trim(),
                              country: _countryController.text.trim(),
                              category: _categoryController.text.trim(),
                              description: _descriptionController.text.trim(),
                              imageUrl: _imageUrlController.text.trim().isEmpty
                                  ? null
                                  : _imageUrlController.text.trim(),
                            );
                            final success = await provider.updateItem(widget.itemId, updatedItem);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(success ? 'Item updated' : 'Update failed')),
                              );
                              if (success) Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
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