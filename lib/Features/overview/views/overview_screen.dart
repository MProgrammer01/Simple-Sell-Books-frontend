import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/typography.dart';
import 'package:sell_your_books/Features/books/data/book_dto.dart';
import 'package:sell_your_books/Features/global/widgets/books_table_widget.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key}); // Fixed syntax error (was 'new')

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  

  final cards = [
    _SummaryCardDTO(
      label: 'Total Books',
      value: '12,450',
      icon: Icons.library_books_outlined,
      iconBg: ColorsApp.primaryFixed,
      iconFg: ColorsApp.onPrimaryFixed,
      footer: '14% from last month',
      footerIsPositive: true,
    ),
    _SummaryCardDTO(
      label: 'Available Books',
      value: '8,230',
      icon: Icons.check_circle_outline,
      iconBg: ColorsApp.secondaryContainer,
      iconFg: ColorsApp.onSecondaryContainer,
      footer: '66% of total',
    ),
     _SummaryCardDTO(
      label: 'Sold Books',
      value: '4,220',
      icon: Icons.shopping_cart_checkout,
      iconBg: ColorsApp.surfaceVariant,
      iconFg: ColorsApp.onSurfaceVariant,
      footer: '8% from last month',
      footerIsPositive: true,
    ),
     _SummaryCardDTO(
      label: 'Total Categories',
      value: '42',
      icon: Icons.label_outline,
      iconBg: ColorsApp.primaryFixed,
      iconFg: ColorsApp.onPrimaryFixed,
      footer: 'Organized genres',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PageHeader(),
              const SizedBox(height: 32),
              _SummaryCardsGrid(cards: cards),
              const SizedBox(height: 24),
              _RecentBooksCard(books: List.empty()),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page Header
// ---------------------------------------------------------------------------

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyApp>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: typography.headlineXL.copyWith(
            letterSpacing: -0.6,
            fontWeight: FontWeight.w600,
            color: ColorsApp.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Platform metrics and recent activity.',
          style: typography.bodyMD.copyWith(
            color: ColorsApp.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Summary Cards
// ---------------------------------------------------------------------------

class _SummaryCardsGrid extends StatelessWidget {
  final List<_SummaryCardDTO> _cards;
  const _SummaryCardsGrid({required this._cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Fallback for double.infinity constraints
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 800.0;

        int columns = 4;
        if (maxWidth < 1200) columns = 3;
        if (maxWidth < 800) columns = 2;
        if (maxWidth < 500) columns = 1;

        const gap = 20.0;
        final cardWidth = (maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in _cards)
              SizedBox(
                width: cardWidth,
                child: _SummaryCard(data: card),
              ),
          ],
        );
      },
    );
  }
}

class _SummaryCardDTO {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String footer;
  final bool footerIsPositive;

  const _SummaryCardDTO({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.footer,
    this.footerIsPositive = false,
  });
}

class _SummaryCard extends StatelessWidget {

  final _SummaryCardDTO data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyApp>()!;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.label.toUpperCase(),
                  style: typography.labelSM.copyWith(
                    letterSpacing: 0.6,
                    color: ColorsApp.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 20, color: data.iconFg),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.value,
            style: typography.headlineXL.copyWith(
              color: ColorsApp.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (data.footerIsPositive) ...[
                Icon(Icons.arrow_upward, size: 16, 
                color: ColorsApp.primary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  data.footer,
                  style: typography.labelSM.copyWith(
                    fontSize: 13,
                    fontWeight: data.footerIsPositive
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: data.footerIsPositive
                        ? ColorsApp.primary
                        : ColorsApp.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recent Books Table
// ---------------------------------------------------------------------------
class BookRowDTO {
  final String title;
  final String author;
  final String category;
  final String status; // 'Available' or 'Sold Out'

  const BookRowDTO({
    required this.title,
    required this.author,
    required this.category,
    required this.status,
  });
}

class _RecentBooksCard extends StatelessWidget {
  final List<ClsBookDTO> _books;

  const _RecentBooksCard({required this._books});

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyApp>()!;
    return Container(
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorsApp.surfaceBright,
              border: Border(
                bottom: BorderSide(color: ColorsApp.outlineVariant),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Books',
                  style: typography.headlineMD.copyWith(
                    color: ColorsApp.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: typography.labelSM.copyWith(
                      color: ColorsApp.primary),
                  ),
                ),
              ],
            ),
          ),
          // Added Horizontal Scroll to prevent overflow on smaller screens
          BooksTableCard(
                books: _books,
                showPagination: false,
                showActions: false, 
                pageNumber: 1, 
                totalCount: 1, 
                pageSize: 1,
              ),
        ],
      ),
    );
  }
}