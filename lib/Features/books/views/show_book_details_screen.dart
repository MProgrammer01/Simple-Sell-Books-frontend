import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/strings.dart';
import 'package:sell_your_books/Features/books/cubit/book_cubit.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/data/conditions_statuses_categories_data.dart';
import 'package:sell_your_books/Features/global/widgets/dialog_widget.dart';
import 'package:sell_your_books/Features/settings/cubit/settings_cubit.dart'as settings;
import 'package:intl/intl.dart';

class ShowBookDetailsScreen extends StatefulWidget {
  final int bookID;
  const ShowBookDetailsScreen({super.key, required this.bookID});

  @override
  State<ShowBookDetailsScreen> createState() => _ShowBookDetailsScreenState();
}

class _ShowBookDetailsScreenState extends State<ShowBookDetailsScreen> {
  bool _hoveringOfBackLink = false;

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

  int bookID = 0;

  bool isEdited = false;

  void _getBookByID(int bookId) {
    context.read<BookCubit>().getBookByID(bookID: bookId);
  }

  @override
  void initState() {
    super.initState();
    bookID = widget.bookID;
    _getBookByID(bookID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackAndActionsRow(),
                const SizedBox(height: 24),
                BlocConsumer<BookCubit, BookState>(
                  listener: (context, state) {
                    if (state is Success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Book Is ${state.message} successfully',
                          ),
                        ),
                      );
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
                            'You are not allowed to view this book',
                          ),
                        ),
                      );
                    } else if (state is NotFound) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No book were found.')),
                      );
                      // Navigator.maybePop(context);
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
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            color: ColorsApp.primary,
                          ),
                        ),
                      );
                    } else if (state is GetBookByIDSuccess) {
                      final book = state.result;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 900;
                          final leftColumn = _buildBookCoverCard(
                            url: book.coverImg,
                          );
                          final rightColumn = _buildRightColumn(book: book);

                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(flex: 4, child: leftColumn),
                                const SizedBox(width: 20),
                                Expanded(flex: 8, child: rightColumn),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              leftColumn,
                              const SizedBox(height: 20),
                              rightColumn,
                            ],
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackAndActionsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;
        final back = _buildBackLink();
        final actions = _buildActionsRow();

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [back, const SizedBox(height: 12), actions],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [back, actions],
        );
      },
    );
  }

  Row _buildActionsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            final bool? result = await Navigator.pushNamed(
              context,
              ClsStingsApp.addOrEditBookScreen,
              arguments: bookID,
            ) as bool?;

            if (!mounted) return;

            if (result == true) {
              _getBookByID(bookID);
              isEdited = true;
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorsApp.onSurface,
            backgroundColor: ColorsApp.surfaceContainerLowest,
            side: BorderSide(color: ColorsApp.outlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Edit', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () => _handleDeleteBook(bookID),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorsApp.error,
            backgroundColor: ColorsApp.surfaceContainerLowest,
            side: BorderSide(color: ColorsApp.error),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Delete', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildBackLink() {
    final color = _hoveringOfBackLink
        ? ColorsApp.primary
        : ColorsApp.onSurfaceVariant;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveringOfBackLink = true),
      onExit: (_) => setState(() => _hoveringOfBackLink = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.maybePop(context, isEdited);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(Icons.arrow_back, size: 18, color: color),
            Text(
              'Back to Books',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCoverCard({required String? url}) {
    return Container(
      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: url == null || url.isEmpty
                ? Icon(
                    Icons.image_outlined,
                    size: 100,
                    color: ColorsApp.onSurface,
                  )
                : Image.network(url, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataCard({
    required String createdAt,
    required String updatedAt,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metadata',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorsApp.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetaRow(label: 'Created Date', value: createdAt),
          _buildMetaRow(label: 'Updated Date', value: updatedAt),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorsApp.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsApp.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorsApp.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorsApp.surfaceContainerHigh),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: ColorsApp.onSurfaceVariant),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: ColorsApp.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn({required ClsBookDTO book}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPrimaryDetailsCard(book: book),
        const SizedBox(height: 20),
        _buildSellerInfoCard(),
        const SizedBox(height: 20),
        _buildMetadataCard(
          createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(book.createdAt),
          updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(book.updatedAt),
          status: ClsConditionsStatusesCategoriesData.getStatuseName(
            book.statusId,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryDetailsCard({required ClsBookDTO book}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 420;
              final titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 30,
                      height: 36 / 30,
                      letterSpacing: -0.6,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${book.author}',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsApp.onSurfaceVariant,
                    ),
                  ),
                ],
              );
              final priceBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${book.price}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${book.stock} in stock',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorsApp.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ColorsApp.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleBlock,
                    const SizedBox(height: 12),
                    priceBlock,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleBlock),
                  priceBlock,
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTagChip(
                label: ClsConditionsStatusesCategoriesData.getCategoryName(
                  book.categoryId,
                ),
              ),
              _buildTagChip(
                label: ClsConditionsStatusesCategoriesData.getConditionName(
                  book.conditionId,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: ColorsApp.surfaceContainerHigh, height: 1),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorsApp.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            book.bookDescription ?? "No Description",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: ColorsApp.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorsApp.surface,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: ColorsApp.onSurfaceVariant),
      ),
    );
  }

  Widget _buildSellerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<settings.SettingsCubit, settings.SettingsState>(
        builder: (context, state) {
          if (state is settings.GetSellerByPersonIDSuccess) {
            final seller = state.result;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: ColorsApp.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seller Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ColorsApp.surfaceContainerHigh,
                          border: Border.all(color: ColorsApp.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          (seller.logoStore == null || seller.logoStore == "string") ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-Z1vX62kKOtkHMh5jkBJDkrg0aNIh0PUjXjtSTMVrKu1F4BdMqIyUBQbFh70Uw3Lz2qczNQr4mWdUt7Dx-4WayFMibmJ-tKyGDmBCC_90MbETpP326WRkJeNEXpjDmSYkW3VBtWLEwKxzgUXPm35QXbXz2BQV_6klLn5v9aUUErBIjtgFjESBWsX7VSQQQkfPKlQBgzOWyrQkRaI0tWllxvfkIT2eh38-PJX2M7DtR8YMids1FTiJxw' : seller.logoStore!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seller.storeName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorsApp.onSurface,
                          ),
                        ),
                        Text(
                          seller.role,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorsApp.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
