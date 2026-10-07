
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Features/books/cubit/book_cubit.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/data/conditions_statuses_categories_data.dart';
import 'package:sell_your_books/Features/global/data/storage.dart';
import 'package:sell_your_books/Features/global/widgets/cover_image_drop_zone.dart';
import 'package:sell_your_books/Features/global/widgets/custom_drop_down_widget.dart';
import 'package:sell_your_books/Features/global/widgets/custom_text_form_field_widget.dart';
import 'package:sell_your_books/Features/global/widgets/labeled_field_widget.dart';

class AddOrEditBookScreen extends StatefulWidget {
  final int bookID;
  const AddOrEditBookScreen({super.key, required this.bookID});

  @override
  State<AddOrEditBookScreen> createState() => _AddOrEditBookScreenState();
}

class _AddOrEditBookScreenState extends State<AddOrEditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  String? _category;
  String? _condition;
  String? _status;

  bool _isEdit = false;

  @override
  void initState() {
    _isEdit = widget.bookID != 0;
    if (_isEdit) {
      context.read<BookCubit>().getBookByID(bookID: widget.bookID);
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _handleAddNew() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final addBookDTO = ClsBookDTO.addNewBook(
      personId: ClsStorage.personID ?? 0,
      categoryId: ClsConditionsStatusesCategoriesData.getCategoryID(_category!),
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      bookDescription: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      stock: int.parse(_stockController.text.trim()),
      conditionId: ClsConditionsStatusesCategoriesData.getConditionID(
        _condition!,
      ),
      coverImg: null,
      statusId: ClsConditionsStatusesCategoriesData.getStatuseID(_status!),
    );

    context.read<BookCubit>().addNewBook(addBookDTO);
  }

  void _handleUpdate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final updateBookDTO = ClsBookDTO.updateBook(
      bookId: widget.bookID,
      categoryId: ClsConditionsStatusesCategoriesData.getCategoryID(_category!),
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      bookDescription: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      stock: int.parse(_stockController.text.trim()),
      conditionId: ClsConditionsStatusesCategoriesData.getConditionID(
        _condition!,
      ),
      // coverImg: coverImgController.text.trim(),
      statusId: ClsConditionsStatusesCategoriesData.getStatuseID(_status!),
    );
    context.read<BookCubit>().updateBook(updateBookDTO);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 896),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                BlocConsumer<BookCubit, BookState>(
                  listener: (context, state) {
                    if (state is GetBookByIDSuccess) {
                      final book = state.result;

                      _titleController.text = book.title;
                      _authorController.text = book.author;
                      _descriptionController.text = book.bookDescription ?? '';

                      _priceController.text = book.price.toString();

                      _stockController.text = book.stock.toString();

                      _category =
                          ClsConditionsStatusesCategoriesData.getCategoryName(
                            book.categoryId,
                          );

                      _condition =
                          ClsConditionsStatusesCategoriesData.getConditionName(
                            book.conditionId,
                          );

                      _status =
                          ClsConditionsStatusesCategoriesData.getStatuseName(
                            book.statusId,
                          );
                    } else if (state is Success) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       'Book Is ${state.message} successfully',
                      //     ),
                      //   ),
                      // );
                      Navigator.pop(context, true); 
                    } else if (state is BadRequest) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Invalid request. Please check your information.',
                          ),
                        ),
                      );
                    } else if (state is Unauthorized) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Your session has expired. Please sign in again.',
                          ),
                        ),
                      );
                    } else if (state is Forbidden) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isEdit
                                ? 'You are not allowed to update this book.'
                                : 'You are not allowed to add this book',
                          ),
                        ),
                      );
                    } else if (state is NotFound) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No book were found.')),
                      );
                      Navigator.maybePop(context);
                    } else if (state is Conflict) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book already exists')),
                      );
                    } else if (state is TooManyRequests) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Too many requests. Please try again later.',
                          ),
                        ),
                      );
                    } else if (state is ServerError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Something went wrong on the server. Please try again later.',
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorsApp.primary,
                        ),
                      );
                    }
                    return _buildFormCard();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(Icons.arrow_back, color: ColorsApp.onSurfaceVariant),
          splashRadius: 20,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_isEdit ? 'Update' : 'Add New'} Book',
                style: TextStyle(
                  fontSize: 30,
                  height: 36 / 30,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w600,
                  color: ColorsApp.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter the details for the new inventory item.',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorsApp.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 640;
                final leftColumn = _buildLeftColumn();
                final rightColumn = _buildRightColumn();

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: leftColumn),
                      const SizedBox(width: 32),
                      Expanded(child: rightColumn),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    leftColumn,
                    const SizedBox(height: 24),
                    rightColumn,
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Divider(color: ColorsApp.outlineVariant, height: 1),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledFieldWidget(
          label: 'Book Title',
          child: CustomTextFormFieldWidget(
            controller: _titleController,
            hintText: 'Enter book title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Book title is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        LabeledFieldWidget(
          label: 'Author',
          child: CustomTextFormFieldWidget(
            controller: _authorController,
            hintText: 'Enter author name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Author name is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        LabeledFieldWidget(
          label: 'Description',
          child: CustomTextFormFieldWidget(
            controller: _descriptionController,
            hintText: 'Provide a brief description...',
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledFieldWidget(
                label: 'Price (\$)',
                child: CustomTextFormFieldWidget(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hintText: '0.00',
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Enter a valid price';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LabeledFieldWidget(
                label: 'Stock Quantity',
                child: CustomTextFormFieldWidget(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  hintText: '0',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stock quantity is required';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity < 0) {
                      return 'Enter a valid stock quantity';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledFieldWidget(
          label: 'Category',
          child: CustomDropDownWidget(
            hint: 'Select a category',
            value: _category,
            items: ClsConditionsStatusesCategoriesData.categories.values
                .toList(),
            onChanged: (value) => setState(() => _category = value),
          ),
        ),
        const SizedBox(height: 24),
        LabeledFieldWidget(
          label: 'Condition',
          child: CustomDropDownWidget(
            hint: 'Select condition',
            value: _condition,
            items: ClsConditionsStatusesCategoriesData.conditions.values
                .toList(),
            onChanged: (value) => setState(() => _condition = value),
          ),
        ),
        const SizedBox(height: 24),
        LabeledFieldWidget(
          label: 'Status',
          child: CustomDropDownWidget(
            hint: 'Select status',
            value: _status,
            items: ClsConditionsStatusesCategoriesData.statuses.values.toList(),
            onChanged: (value) => setState(() => _status = value),
          ),
        ),
        const SizedBox(height: 24),
        const LabeledFieldWidget(
          label: 'Cover Image',
          child: CoverImageDropzone(),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 16,
      runSpacing: 12,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.maybePop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorsApp.onSurface,
            backgroundColor: ColorsApp.surfaceContainerLowest,
            side: BorderSide(color: ColorsApp.outlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        ElevatedButton(
          onPressed: _isEdit ? _handleUpdate : _handleAddNew,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsApp.primary,
            foregroundColor: ColorsApp.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
          ),
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}


