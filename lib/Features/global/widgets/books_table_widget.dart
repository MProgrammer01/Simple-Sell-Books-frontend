import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/data/conditions_statuses_categories_data.dart';
import 'package:sell_your_books/Features/global/widgets/action_icon_button_widget.dart';

// ---------------------------------------------------------------------------
// Books table
// ---------------------------------------------------------------------------

class BooksTableCard extends StatefulWidget {
  final List<ClsBookDTO> _books;
  final int _pageNumber;
  final void Function()? _onTapNext;
  final void Function()? _onTapPrevious;
  final bool _showPagination, _showActions;
  final void Function(int bookId)? _onTapView;
  final void Function(int bookId)? _onTapEdit;
  final void Function(int bookId)? _onTapDelete;

  final int _totalCount;
  final int _pageSize;

  const BooksTableCard({
    super.key,
    required this._books,
    required this._pageNumber,
    this._onTapNext,
    this._onTapPrevious,
    required this._showPagination,
    required this._showActions,
    required this._totalCount,
    required this._pageSize,
    this._onTapView,
    this._onTapEdit,
    this._onTapDelete,
  });

  @override
  State<BooksTableCard> createState() => _BooksTableCardState();
}

class _BooksTableCardState extends State<BooksTableCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      ColorsApp.surfaceContainerLow,
                    ),
                    dataRowMinHeight: 72,
                    dataRowMaxHeight: 72,
                    columnSpacing: 24,
                    columns: [
                      DataColumn(label: _buildHeaderCell('Book Details')),
                      DataColumn(label: _buildHeaderCell('Category')),
                      DataColumn(label: _buildHeaderCell('Price')),
                      DataColumn(label: _buildHeaderCell('Stock / Condition')),
                      DataColumn(label: _buildHeaderCell('Status')),
                      DataColumn(label: _buildHeaderCell('Created')),
                      if (widget._showActions)
                        DataColumn(label: _buildHeaderCell('Actions')),
                    ],
                    rows: [
                      for (final book in widget._books) _buildRow(book: book),
                    ],
                  ),
                ),
              );
            },
          ),
          if (widget._showPagination)
            _Pagination(
              pageNumber: widget._pageNumber,
              onTapNext: widget._onTapNext ?? () {},
              onTapPrevious: widget._onTapPrevious ?? () {},
              totalPages: (widget._totalCount / widget._pageSize).ceil(),
              totalCount: widget._totalCount,
              pageSize: widget._pageSize,
            ),
        ],
      ),
    );
  }

  DataRow _buildRow({required ClsBookDTO book}) {
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 260,
            child: Row(
              children: [
                _buildBookCover(book.coverImg),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorsApp.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Text(
            ClsConditionsStatusesCategoriesData.getCategoryName(
              book.categoryId,
            ),
            style: TextStyle(color: ColorsApp.onSurfaceVariant),
          ),
        ),
        DataCell(
          Text(
            book.price.toString(),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                book.stock.toString(),
                style: TextStyle(
                  color: book.stock == 0
                      ? ColorsApp.error
                      : ColorsApp.onSurface,
                ),
              ),
              Text(
                ClsConditionsStatusesCategoriesData.getConditionName(
                  book.conditionId,
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: ColorsApp.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          _buildStatusPill(
            ClsConditionsStatusesCategoriesData.getStatuseName(book.statusId),
          ),
        ),
        DataCell(
          Text(
            DateFormat('yyyy-MM-dd HH:mm:ss').format(book.createdAt),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: ColorsApp.onSurfaceVariant,
            ),
          ),
        ),
        if (widget._showActions) DataCell(_buildRowActions(booID: book.bookId)),
      ],
    );
  }

  Widget _buildBookCover(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        width: 40,
        height: 56,
        decoration: BoxDecoration(
          color: ColorsApp.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ColorsApp.outlineVariant),
        ),
        child: Icon(
          Icons.image_outlined,
          size: 22,
          color: ColorsApp.outlineVariant,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 40,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: ColorsApp.outlineVariant),
          // borderRadius: BorderRadius.circular(4),
        ),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: ColorsApp.onSurfaceVariant,
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'Available':
        bg = ColorsApp.statusAvailableBg;
        fg = ColorsApp.statusAvailableFg;
        break;

      case 'Sold':
        bg = ColorsApp.statusSoldOutBg;
        fg = ColorsApp.statusSoldOutFg;
        break;

      case 'Reserved':
        bg = ColorsApp.tertiaryFixed;
        fg = ColorsApp.onTertiaryFixedVariant;
        break;

      case 'Hidden':
        bg = ColorsApp.surfaceContainerHighest;
        fg = ColorsApp.onSurfaceVariant;
        break;
      default:
        bg = ColorsApp.surfaceContainerHigh;
        fg = ColorsApp.onSurfaceVariant;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }

  Widget _buildRowActions({required int booID}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionIconButtonWidget(
          icon: Icons.visibility_outlined,
          tooltip: 'View',
          hoverColor: ColorsApp.primary,
          hoverBg: ColorsApp.primaryFixed,
          onTap: () => widget._onTapView!(booID),
        ),

        ActionIconButtonWidget(
          icon: Icons.edit_outlined,
          tooltip: 'Edit',
          hoverColor: ColorsApp.primary,
          hoverBg: ColorsApp.primaryFixed,
          onTap: () => widget._onTapEdit!(booID),
        ),

        ActionIconButtonWidget(
          icon: Icons.delete_outline,
          tooltip: 'Delete',
          hoverColor: ColorsApp.error,
          hoverBg: ColorsApp.errorContainer,
          onTap: () => widget._onTapDelete!(booID),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pagination
// ---------------------------------------------------------------------------

class _Pagination extends StatelessWidget {
  final VoidCallback _onTapNext;
  final VoidCallback _onTapPrevious;

  final int totalPages;
  final int totalCount;
  final int pageSize;
  final int pageNumber;

  const _Pagination({
    required this._onTapNext,
    required this._onTapPrevious,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border(top: BorderSide(color: ColorsApp.outlineVariant)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final startIndex = ((pageNumber - 1) * pageSize) + 1;

          final endIndex = min(pageNumber * pageSize, totalCount);

          final info = RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: ColorsApp.onSurfaceVariant),
              children: [
                const TextSpan(text: 'Showing '),

                TextSpan(
                  text: '$startIndex',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.onSurface,
                  ),
                ),

                const TextSpan(text: ' to '),

                TextSpan(
                  text: '$endIndex',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.onSurface,
                  ),
                ),

                const TextSpan(text: ' of '),

                TextSpan(
                  text: '$totalCount',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.onSurface,
                  ),
                ),

                const TextSpan(text: ' results'),
              ],
            ),
          );

          final controls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PageButton(
                icon: Icons.chevron_left,
                onTap: _onTapPrevious,
                isDisabled: pageNumber == 1,
              ),

              const SizedBox(width: 4),

              _PageButton(label: '$pageNumber', selected: true),

              const SizedBox(width: 4),

              _PageButton(
                icon: Icons.chevron_right,
                onTap: _onTapNext,
                isDisabled: pageNumber == totalPages,
              ),
            ],
          );

          if (constraints.maxWidth < 480) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [info, const SizedBox(height: 12), controls],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [info, controls],
          );
        },
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool selected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _PageButton({
    this.label,
    this.icon,
    this.selected = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: selected ? ColorsApp.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: isDisabled ? null : onTap,
          child: Container(
            decoration: BoxDecoration(
              border: selected
                  ? null
                  : Border.all(color: ColorsApp.outlineVariant),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 20, color: ColorsApp.onSurfaceVariant)
                  : Text(
                      label!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: selected
                            ? ColorsApp.onPrimary
                            : ColorsApp.onSurfaceVariant,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
