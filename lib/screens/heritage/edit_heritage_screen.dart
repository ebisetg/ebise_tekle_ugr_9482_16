import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/heritage_provider.dart';
import '../../models/heritage_item.dart';
import '../../core/utils/validators.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_widget.dart';

class EditHeritageScreen extends StatefulWidget {
  final String itemId;

  const EditHeritageScreen({
    super.key,
    required this.itemId,
  });

  @override
  State<EditHeritageScreen> createState() =>
      _EditHeritageScreenState();
}

class _EditHeritageScreenState
    extends State<EditHeritageScreen> {
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

    final provider =
        context.read<HeritageProvider>();

    _item = provider.getItemById(widget.itemId);

    _nameController =
        TextEditingController(text: _item?.name ?? '');

    _countryController =
        TextEditingController(
      text: _item?.country ?? '',
    );

    _categoryController =
        TextEditingController(
      text: _item?.category ?? '',
    );

    _descriptionController =
        TextEditingController(
      text: _item?.description ?? '',
    );

    _imageUrlController =
        TextEditingController(
      text: _item?.imageUrl ?? '',
    );
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
          appBar: AppBar(),

          body: provider.isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Heritage',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Update cultural heritage information.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _nameController,
                                label: 'Title',
                                validator: (v) =>
                                    Validators.validateRequired(
                                  v,
                                  'Title',
                                ),
                              ),

                              const SizedBox(height: 18),

                              CustomTextField(
                                controller:
                                    _countryController,
                                label: 'Country / Region',
                                validator: (v) =>
                                    Validators
                                        .validateRequired(
                                  v,
                                  'Country',
                                ),
                              ),

                              const SizedBox(height: 18),

                              CustomTextField(
                                controller:
                                    _categoryController,
                                label: 'Category',
                                validator: (v) =>
                                    Validators
                                        .validateRequired(
                                  v,
                                  'Category',
                                ),
                              ),

                              const SizedBox(height: 18),

                              CustomTextField(
                                controller:
                                    _descriptionController,
                                label: 'Description',
                                maxLines: 4,
                                validator: (v) =>
                                    Validators
                                        .validateRequired(
                                  v,
                                  'Description',
                                ),
                              ),

                              const SizedBox(height: 18),

                              CustomTextField(
                                controller:
                                    _imageUrlController,
                                label: 'Image URL',
                                validator:
                                    Validators.validateUrl,
                              ),

                              const SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey
                                        .currentState!
                                        .validate()) {
                                      return;
                                    }

                                    final updatedItem =
                                        _item!.copyWith(
                                      name:
                                          _nameController.text
                                              .trim(),
                                      country:
                                          _countryController
                                              .text
                                              .trim(),
                                      category:
                                          _categoryController
                                              .text
                                              .trim(),
                                      description:
                                          _descriptionController
                                              .text
                                              .trim(),
                                      imageUrl:
                                          _imageUrlController
                                                  .text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _imageUrlController
                                                  .text
                                                  .trim(),
                                    );

                                    final success =
                                        await provider
                                            .updateItem(
                                      widget.itemId,
                                      updatedItem,
                                    );

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? 'Item updated'
                                                : 'Update failed',
                                          ),
                                        ),
                                      );

                                      if (success) {
                                        Navigator.pop(
                                            context);
                                      }
                                    }
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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