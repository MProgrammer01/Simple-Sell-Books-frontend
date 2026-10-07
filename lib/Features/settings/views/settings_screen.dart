import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/strings.dart';
import 'package:sell_your_books/Features/global/data/storage.dart';
import 'package:sell_your_books/Features/global/widgets/cover_image_drop_zone.dart';
import 'package:sell_your_books/Features/global/widgets/custom_text_form_field_widget.dart';
import 'package:sell_your_books/Features/global/widgets/dialog_widget.dart';
import 'package:sell_your_books/Features/global/widgets/labeled_field_widget.dart';
import 'package:sell_your_books/Features/global/widgets/obscure_toggle_widget.dart';
import 'package:sell_your_books/Features/settings/cubit/settings_cubit.dart';
import 'package:sell_your_books/Features/settings/data/settings_dto.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _storeNameController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _storeNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleSaveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Updating profile...')));
    final updateSeller = ClsSettingsDto.updateSeller(
      personID: ClsStorage.personID ?? 0,
      storeName: _storeNameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      addressPerson: _addressController.text.trim(),
      // logoStore: _,
      phone: _phoneController.text.trim(),
    );
    context.read<SettingsCubit>().updateSeller(updateSeller);
  }

  void _handleUpdatePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Updating password...')));

    final changePasswordDTO = ClsChangePasswordDTO(
      personID: ClsStorage.personID ?? 0,
      oldPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );
    context.read<SettingsCubit>().changePassword(changePasswordDTO);
  }

  void _handleDeleteAccount() {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return DialogWidget(
            dialogTitle: 'Delete Account?',
            dialogContent: 'This action cannot be undone. All of your data will be permanently removed.',
            actionTitle: isDeleting ? 'Deleting...' : 'Delete',
            foregroundColor: ColorsApp.error,
            dialogOnPressed: isDeleting
                ? null
                : () async {
                    setDialogState(() => isDeleting = true);
                    try {
                      await context
                          .read<SettingsCubit>()
                          .deleteSellerByPersonID(
                            personID: ClsStorage.personID ?? 0,
                          );

                      if (!dialogContext.mounted) return;
                      Navigator.of(dialogContext).pop();
                    } catch (e) {
                      if (!dialogContext.mounted) return;
                      setDialogState(() => isDeleting = false);

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete account.'),
                        ),
                      );
                    }
                  },
          );
        },
      ),
    );
  }

  void _getSellerByPersonID() {
    context.read<SettingsCubit>().getSellerByPersonID(
      personID: ClsStorage.personID ?? 0,
    );
  }

  bool _hoveringProfile = false;
  bool _hoveringSecurity = false;
  bool _hoveringDanger = false;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHeader(),
                const SizedBox(height: 24),
                _buildSettingsTabBar(),
              ],
            ),
          ),
          Divider(height: 1, color: ColorsApp.outlineVariant),
          BlocConsumer<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state is GetSellerByPersonIDSuccess) {
                final seller = state.result;

                _fullNameController.text = seller.fullName;
                _emailController.text = seller.email;
                _phoneController.text = seller.phone ?? '';

                _addressController.text = seller.addressPerson ?? '';
                _storeNameController.text = seller.storeName;
              } else if (state is SuccessUpdatedSeller) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Seller Is Updated Successfully')),
                );
                _getSellerByPersonID();
              } else if (state is SuccessChangedPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password Is Updated Successfully')),
                );
                ClsStorage.clearData();
                Navigator.pushReplacementNamed(
                  context,
                  ClsStingsApp.signInScreen,
                );
              } else if (state is SuccessDeletedSeller) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your Account Is Deleted Successfully')),
                );
                ClsStorage.clearData();
                Navigator.pushReplacementNamed(
                  context,
                  ClsStingsApp.signInScreen,
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
                  SnackBar(
                    content: Text('You are not allowed to update this seller.'),
                  ),
                );
              } else if (state is NotFound) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No seller were found.')),
                );
              } else if (state is Conflict) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seller already exists')),
                );
              } else if (state is TooManyRequests) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Too many requests. Please try again later.'),
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
                  child: CircularProgressIndicator(color: ColorsApp.primary),
                );
              }
              return Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, _) {
                      switch (_tabController.index) {
                        case 1:
                          return _buildSecurityCardState();
                        case 2:
                          return _buildDangerZoneCard();
                        default:
                          return _buildProfileInformationCard();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 30,
            height: 36 / 30,
            letterSpacing: -0.6,
            fontWeight: FontWeight.w600,
            color: ColorsApp.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account preferences and security settings.',
          style: TextStyle(fontSize: 16, color: ColorsApp.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildSettingsTabBar() {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return Row(
          children: [
            _buildSettingsTab(
              label: 'Profile Information',
              selected: _tabController.index == 0,
              onTap: () => _tabController.animateTo(0),
              hovering: _hoveringProfile,
              onHoverChanged: (value) {
                setState(() => _hoveringProfile = value);
              },
            ),
            _buildSettingsTab(
              label: 'Security',
              selected: _tabController.index == 1,
              onTap: () => _tabController.animateTo(1),
              hovering: _hoveringSecurity,
              onHoverChanged: (value) {
                setState(() => _hoveringSecurity = value);
              },
            ),
            _buildSettingsTab(
              label: 'Danger Zone',
              selected: _tabController.index == 2,
              isDanger: true,
              onTap: () => _tabController.animateTo(2),
              hovering: _hoveringDanger,
              onHoverChanged: (value) {
                setState(() => _hoveringDanger = value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool isDanger = false,
    required bool hovering,
    required ValueChanged<bool> onHoverChanged,
  }) {
    final activeColor = isDanger ? ColorsApp.error : ColorsApp.primary;

    final Color textColor;

    if (selected) {
      textColor = activeColor;
    } else if (isDanger) {
      textColor = activeColor.withValues(alpha: 0.85);
    } else {
      textColor = ColorsApp.onSurfaceVariant;
    }

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: hovering && !selected
              ? ColorsApp.surfaceContainerHigh.withValues(alpha: 0.5)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInformationCard() {
    return buildSettingsCard(
      title: 'Profile Information',
      subtitle: 'Update your personal details and contact information.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 520;
              final fields = [
                LabeledFieldWidget(
                  label: 'Full Name',
                  child: CustomTextFormFieldWidget(
                    controller: _fullNameController,
                    hintText: 'Enter full name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                ),

                LabeledFieldWidget(
                  label: 'Email Address',
                  child: CustomTextFormFieldWidget(
                    controller: _emailController,
                    hintText: 'Enter email address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email address is required';
                      }
                      return null;
                    },
                  ),
                ),

                LabeledFieldWidget(
                  label: 'Phone Number',
                  child: CustomTextFormFieldWidget(
                    controller: _phoneController,
                    hintText: 'Enter phone number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                ),

                LabeledFieldWidget(
                  label: 'Store Name',
                  child: CustomTextFormFieldWidget(
                    controller: _storeNameController,
                    hintText: 'My Store',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Store Name is required';
                      }
                      return null;
                    },
                  ),
                ),

                LabeledFieldWidget(
                  label: 'Address',
                  child: CustomTextFormFieldWidget(
                    controller: _addressController,
                    hintText: 'Enter address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                    maxLines: 4,
                  ),
                ),

                const LabeledFieldWidget(
                  label: 'Logo Store',
                  child: CoverImageDropzone(),
                ),
              ];

              if (isWide) {
                return Column(
                  spacing: 24,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: fields[0]),
                        const SizedBox(width: 24),
                        Expanded(child: fields[1]),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: fields[2]),
                        const SizedBox(width: 24),
                        Expanded(child: fields[3]),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: fields[4]),
                        const SizedBox(width: 24),
                        Expanded(child: fields[5]),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  ...fields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: field,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Divider(color: ColorsApp.surfaceContainerHigh, height: 1),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _handleSaveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsApp.primary,
                foregroundColor: ColorsApp.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCardState() {
    return buildSettingsCard(
      title: 'Security',
      subtitle: 'Manage your password and account access.',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 448), // max-w-md
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabeledFieldWidget(
              label: 'Current Password',
              child: CustomTextFormFieldWidget(
                controller: _currentPasswordController,
                hintText: 'Enter current password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Current Password is required';
                  }
                  if (value.length < 8) {
                    return 'Use at least 8 characters';
                  }
                  return null;
                },
                obscureText: _obscureCurrent,
                suffixIcon: ObscureToggleWidget(
                  obscured: _obscureCurrent,
                  onTap: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
            ),

            LabeledFieldWidget(
              label: 'New Password',
              child: CustomTextFormFieldWidget(
                controller: _newPasswordController,
                hintText: 'Enter new password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'New Password is required';
                  }
                  if (value.length < 8) {
                    return 'Use at least 8 characters';
                  }
                  return null;
                },
                obscureText: _obscureNew,
                suffixIcon: ObscureToggleWidget(
                  obscured: _obscureNew,
                  onTap: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
            ),

            LabeledFieldWidget(
              label: 'Confirm New Password',
              child: CustomTextFormFieldWidget(
                controller: _confirmPasswordController,
                hintText: 'Confirm new password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: _obscureConfirm,
                suffixIcon: ObscureToggleWidget(
                  obscured: _obscureConfirm,
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: _handleUpdatePassword,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorsApp.onSurface,
                  backgroundColor: ColorsApp.surfaceContainerLowest,
                  side: BorderSide(color: ColorsApp.outline),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update Password',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLowest,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorsApp.outlineVariant),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsApp.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Form(key: _formKey, child: child),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          ColorsApp.error.withValues(alpha: 0.05),
          ColorsApp.surfaceContainerLowest,
        ),
        border: Border.all(color: ColorsApp.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 640;

          final textBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: ColorsApp.error,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Permanently delete your account and all associated data. '
                'This action cannot be undone. Please be certain before proceeding.',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorsApp.onSurfaceVariant,
                ),
              ),
            ],
          );
          final deleteButton = ElevatedButton(
            onPressed: _handleDeleteAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsApp.error,
              foregroundColor: ColorsApp.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Delete Account',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: textBlock),
                const SizedBox(width: 24),
                deleteButton,
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [textBlock, const SizedBox(height: 24), deleteButton],
          );
        },
      ),
    );
  }
}
