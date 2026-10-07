import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/strings.dart';
import 'package:sell_your_books/Features/books/views/manage_books_screen.dart';
import 'package:sell_your_books/Features/global/data/storage.dart';
import 'package:sell_your_books/Features/settings/cubit/settings_cubit.dart';
import 'package:sell_your_books/Features/settings/views/settings_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    // OverviewScreen(),
    ManageBooksScreen(),
    SettingsScreen(),
  ];

  void _onSelect(int index) {
    _selectedIndexNotifier.value = index;
  }

  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().getSellerByPersonID(
      personID: ClsStorage.personID ?? 0,
    );
  }

  @override
  void dispose() {
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SideNavBar(
            onSelect: _onSelect,
            selectedIndexNotifier: _selectedIndexNotifier,
          ),
          Expanded(
            child: Column(
              children: [
                const _TopNavBar(),
                const Divider(height: 1),
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: _selectedIndexNotifier,
                    builder: (context, value, child) {
                      return IndexedStack(index: value, children: _pages);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Side Nav Bar
// ---------------------------------------------------------------------------
class _SideNavBar extends StatelessWidget {
  final ValueNotifier<int> _selectedIndexNotifier;
  final ValueChanged<int> _onSelect;
  const _SideNavBar({
    required this._selectedIndexNotifier,
    required this._onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border(right: BorderSide(color: ColorsApp.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Simple Sell Books',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorsApp.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Management Suite',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorsApp.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _selectedIndexNotifier,
              builder: (context, value, child) {
                return ListView(
                  children: [
                    // _NavItem(
                    //   icon: Icons.dashboard,
                    //   label: 'Dashboard',
                    //   selected: value == 0,
                    //   onTap: () => _onSelect(0),
                    // ),
                    _NavItem(
                      icon: Icons.menu_book_outlined,
                      label: 'Books',
                      selected: value == 0,
                      onTap: () => _onSelect(0),
                    ),
                    _NavItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      selected: value == 1,
                      onTap: () => _onSelect(1),
                    ),
                  ],
                );
              },
            ),
          ),
          _NavItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () => {
              ClsStorage.clearData(),
              Navigator.pushReplacementNamed(
                context,
                ClsStingsApp.signInScreen,
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? ColorsApp.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? ColorsApp.onSecondaryContainer
                      : ColorsApp.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: selected
                        ? ColorsApp.onSecondaryContainer
                        : ColorsApp.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top Nav Bar
// ---------------------------------------------------------------------------
class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceBright,
        border: Border(bottom: BorderSide(color: ColorsApp.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: ColorsApp.onSurfaceVariant,
                ),
                splashRadius: 20,
              ),
              const SizedBox(width: 8),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is GetSellerByPersonIDSuccess) {
                    final seller = state.result;
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorsApp.outlineVariant),
                        image: DecorationImage(
                          image: NetworkImage(
                            (seller.logoStore == null ||
                                    seller.logoStore == "string")
                                ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-Z1vX62kKOtkHMh5jkBJDkrg0aNIh0PUjXjtSTMVrKu1F4BdMqIyUBQbFh70Uw3Lz2qczNQr4mWdUt7Dx-4WayFMibmJ-tKyGDmBCC_90MbETpP326WRkJeNEXpjDmSYkW3VBtWLEwKxzgUXPm35QXbXz2BQV_6klLn5v9aUUErBIjtgFjESBWsX7VSQQQkfPKlQBgzOWyrQkRaI0tWllxvfkIT2eh38-PJX2M7DtR8YMids1FTiJxw'
                                : seller.logoStore!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
