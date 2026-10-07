import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/strings.dart';
import 'package:sell_your_books/Features/books/cubit/book_cubit.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/data/conditions_statuses_categories_data.dart';
import 'package:sell_your_books/Features/global/data/storage.dart';
import 'package:sell_your_books/Features/global/widgets/books_table_widget.dart';
import 'package:sell_your_books/Features/global/widgets/custom_drop_down_widget.dart';
import 'package:sell_your_books/Features/global/widgets/custom_text_form_field_widget.dart';
import 'package:sell_your_books/Features/global/widgets/dialog_widget.dart';
import 'package:sell_your_books/Features/global/widgets/labeled_field_widget.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchByController = TextEditingController();

  String? _category;
  String? _condition;
  String? _status;

  final int pageSize = 10;

  int _currentPageNumber = 1;

  List<ClsBookDTO> books = List.empty();
  int totalCount = 0;

  void _goToNextPage() {
    final totalPages = (totalCount / pageSize).ceil();

    if (_currentPageNumber < totalPages) {
      final nextPage = _currentPageNumber + 1;

      _currentPageNumber = nextPage;

      context.read<BookCubit>().getAllBooks(
        pageNumber: nextPage,
        pageSize: pageSize,
        personID: ClsStorage.personID ?? 0
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPageNumber > 1) {
      final previousPage = _currentPageNumber - 1;

      _currentPageNumber = previousPage;

      context.read<BookCubit>().getAllBooks(
        pageNumber: previousPage,
        pageSize: pageSize,
        personID: ClsStorage.personID ?? 0
      );
    }
  }

  void _getAllBooks() {
    context.read<BookCubit>().getAllBooks(
      pageNumber: _currentPageNumber,
      pageSize: pageSize,
      personID: ClsStorage.personID ?? 0
    );
  }

  void _handleDeleteBook(int bookID) {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return DialogWidget(
            dialogTitle: 'Delete Book?',
            dialogContent: 'This action cannot be undone. All of book data will be permanently removed.',
            actionTitle: isDeleting ? 'Deleting...' : 'Delete',
            foregroundColor: ColorsApp.error,
            dialogOnPressed: isDeleting
                ? null
                : () async {
                    setDialogState(() => isDeleting = true);
                    try {
                      await context.read<BookCubit>().deleteBookByID(
                        bookID: bookID,
                      );

                      if (!dialogContext.mounted) return;
                      Navigator.of(dialogContext).pop();

                      if (!mounted) return;
                      _getAllBooks();
                    } catch (e) {
                      if (!dialogContext.mounted) return;
                      setDialogState(() => isDeleting = false);

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete the book.'),
                        ),
                      );
                    }
                  },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAllBooks();
  }

  @override
  void dispose() {
    _searchByController.dispose();
    super.dispose();
  }

  void _notImplementedYet(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("This feature is not implemented yet: $message")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              const SizedBox(height: 32),
              _buildFiltersBar(),
              const SizedBox(height: 24),
              BlocConsumer<BookCubit, BookState>(
                listener: (context, state) {
                  if (state is GetBooksSuccess) {
                    final result = state.result;
                    books = result.books;
                    totalCount = result.totalCount;
                  } else if (state is Success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Book Is ${state.message} successfully'),
                      ),
                    );
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
                      const SnackBar(
                        content: Text(
                          'You are not allowed to view these books.',
                        ),
                      ),
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
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: ColorsApp.primary,
                        ),
                      ),
                    );
                  } else if (state is NotFound) {
                    return Center(
                      child: Text(
                        'No books were found.',
                        style: TextStyle(
                          fontSize: 30,
                          height: 36 / 30,
                          letterSpacing: -0.6,
                          fontWeight: FontWeight.w600,
                          color: ColorsApp.onSurface,
                        ),
                      ),
                    );
                  }

                  return BooksTableCard(
                    books: books,
                    pageNumber: _currentPageNumber,
                    onTapNext: _goToNextPage,
                    onTapPrevious: _goToPreviousPage,
                    showPagination: true,
                    showActions: true,

                    totalCount: totalCount,
                    pageSize: pageSize,

                    onTapView: (bookID) async {
                      final bool? result = await Navigator.pushNamed(
                        context,
                        ClsStingsApp.showBookDetailsScreen,
                        arguments: bookID,
                      ) as bool?;

                      if (!mounted) return;

                      if (result == true) {
                        _getAllBooks();
                      }
                    },

                    onTapEdit: (bookID) async {
                      final bool? result = await Navigator.pushNamed(
                        context,
                        ClsStingsApp.addOrEditBookScreen,
                        arguments: bookID,
                      ) as bool?;

                      if (!mounted) return;

                      if (result == true) {
                        _getAllBooks();
                      }
                    },

                    onTapDelete: (bookID) {
                      _handleDeleteBook(bookID);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Books',
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
              'Manage all books in the system',
              style: TextStyle(fontSize: 14, color: ColorsApp.onSurfaceVariant),
            ),
          ],
        );
        final addButton = ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              ClsStingsApp.addOrEditBookScreen,
            );

            if (result == true && mounted) {
              _getAllBooks();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsApp.primary,
            foregroundColor: ColorsApp.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Add Book',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [title, const SizedBox(height: 16), addButton],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [title, addButton],
        );
      },
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            final searchField = LabeledFieldWidget(
              label: 'Search Books',
              child: CustomTextFormFieldWidget(
                controller: _searchByController,
                hintText: 'Provide a brief description...',

                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: ColorsApp.onSurfaceVariant,
                ),
              ),
            );

            final categoryDropdown = LabeledFieldWidget(
              label: 'Category',
              child: CustomDropDownWidget(
                hint: 'Select a category',
                value: _category,
                items: ClsConditionsStatusesCategoriesData.categories.values
                .toList(),
                onChanged: (value) => setState(() => _category = value),
              ),
            );

            final conditionDropdown = LabeledFieldWidget(
              label: 'Condition',
              child: CustomDropDownWidget(
                hint: 'Select condition',
                value: _condition,
                items: ClsConditionsStatusesCategoriesData.conditions.values
                .toList(),
                onChanged: (value) => setState(() => _condition = value),
              ),
            );

            final statusDropdown = LabeledFieldWidget(
              label: 'Status',
              child: CustomDropDownWidget(
                hint: 'Select status',
                value: _status,
                items: ClsConditionsStatusesCategoriesData.statuses.values
                .toList(),
                onChanged: (value) => setState(() => _status = value),
              ),
            );

            final searchButton = SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  _notImplementedYet("Search");
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorsApp.onSurfaceVariant,
                  backgroundColor: ColorsApp.surface,
                  side: BorderSide(color: ColorsApp.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Search', style: TextStyle(fontSize: 14)),
              ),
            );

            final resetButton = SizedBox(
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  _notImplementedYet("Reset Filters");
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorsApp.onSurfaceVariant,
                  backgroundColor: ColorsApp.surface,
                  side: BorderSide(color: ColorsApp.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  'Reset Filters',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 2, child: searchField),
                  const SizedBox(width: 16),
                  Expanded(child: categoryDropdown),
                  const SizedBox(width: 16),
                  Expanded(child: conditionDropdown),
                  const SizedBox(width: 16),
                  Expanded(child: statusDropdown),
                  const SizedBox(width: 16),
                  searchButton,
                  const SizedBox(width: 16),
                  resetButton,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: categoryDropdown),
                    const SizedBox(width: 16),
                    Expanded(child: conditionDropdown),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: statusDropdown),
                    const SizedBox(width: 16),
                    searchButton,
                    const SizedBox(width: 16),
                    resetButton,
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
