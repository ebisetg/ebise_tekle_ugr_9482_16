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
  State<AddHeritageScreen> createState() =>
      _AddHeritageScreenState();
}

class _AddHeritageScreenState
    extends State<AddHeritageScreen> {
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
          appBar: AppBar(
            title: const Text('Add Heritage'),
          ),

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
                          'New Heritage Item',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Add cultural heritage information.',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _nameController,
                                label: 'Title',
                                validator: (v) =>
                                    Validators
                                        .validateRequired(
                                  v,
                                  'Title',
                                ),
                              ),

                              const SizedBox(height: 16),

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

                              const SizedBox(height: 16),

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

                              const SizedBox(height: 16),

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

                              const SizedBox(height: 16),

                              CustomTextField(
                                controller:
                                    _imageUrlController,
                                label: 'Image URL',
                                validator:
                                    Validators.validateUrl,
                              ),

                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey
                                        .currentState!
                                        .validate()) {
                                      return;
                                    }

                                    final newItem =
                                        HeritageItem(
                                      id: '0',
                                      title:
                                          _nameController.text
                                              .trim(),
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
                                            .addItem(
                                      newItem,
                                    );

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? 'Item added'
                                                : 'Failed to add item',
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
                                      vertical: 14,
                                    ),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w600,
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