import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/typography.dart';
import 'package:sell_your_books/Features/Auth/cubit/auth_cubit.dart';
import 'package:sell_your_books/Features/Auth/data/auth_dtos.dart';
import 'package:sell_your_books/Features/global/widgets/custom_text_form_field_widget.dart';
import 'package:sell_your_books/Features/global/widgets/labeled_field_widget.dart';
import 'package:sell_your_books/Features/global/widgets/obscure_toggle_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _storeNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfermPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final signUpDTO = ClsSignUPSellerDTO(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      storeName: _storeNameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressPerson: _addressController.text.trim(),
      // logoStore: '',
    );

    context.read<AuthCubit>().signUpSeller(signUpDTO);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyApp>()!;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
           ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Account Created Success')));
          Navigator.maybePop(context);
        } else if (state is SignUpEmailAlreadyExists) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Email Already Exists')));
        } else if (state is SignUpTooManyRequests) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Too many attempts. Try again later.'),
            ),
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Something went wrong. Status: ${state.statusCode}',
              ),
            ),
          );
        }
      },

      builder: (context, state) {
        isLoading = state is AuthLoading;
        return Scaffold(
          body: Center(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context)
                  .copyWith(scrollbars: false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Container(
                    padding: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      color: ColorsApp.surfaceContainerLowest,
                      border: Border.all(color: ColorsApp.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(typography: typography),
                        _buildForm(typography: typography),
                        _buildFooter(typography: typography),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader({required TypographyApp typography}) {
    return Column(
      children: [
        Text(
          'Simple Sell Books',
          textAlign: TextAlign.center,
          style: typography.headlineXL.copyWith(
            letterSpacing: -0.6,
            color: ColorsApp.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your account',
          textAlign: TextAlign.center,
          style: typography.bodyMD.copyWith(color: ColorsApp.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildForm({required TypographyApp typography}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledFieldWidget(
              label: 'Full Name*',
              child: CustomTextFormFieldWidget(
                controller: _fullNameController,
                hintText: 'MProgrammer',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),
            ),

            LabeledFieldWidget(
              label: 'Email*',
              child: CustomTextFormFieldWidget(
                controller: _emailController,
                hintText: 'you@example.com',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ),

            LabeledFieldWidget(
              label: 'Phone',
              child: CustomTextFormFieldWidget(
                controller: _phoneController,
                hintText: '06154785',
                keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Phone is required';
                //   }
                //   if (value.length < 10) {
                //     return 'Enter a valid phone number';
                //   }
                //   return null;
                // },
              ),
            ),

            LabeledFieldWidget(
              label: 'Address',
              child: CustomTextFormFieldWidget(
                controller: _addressController,
                hintText: '123 Main St, City, State',
                keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Address is required';
                //   }
                //   if (value.length < 10) {
                //     return 'Enter a valid address';
                //   }
                //   return null;
                // },
              ),
            ),

            LabeledFieldWidget(
              label: 'Store Name*',
              child: CustomTextFormFieldWidget(
                controller: _storeNameController,
                hintText: 'My Store',
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Store Name is required';
                  }
                  return null;
                },
              ),
            ),

            LabeledFieldWidget(
              label: 'Password*',
              child: CustomTextFormFieldWidget(
                controller: _passwordController,
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
                obscureText: _obscurePassword,
                suffixIcon: ObscureToggleWidget(
                  obscured: _obscurePassword,
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),

            LabeledFieldWidget(
              label: 'Confirm Password*',
              child: CustomTextFormFieldWidget(
                controller: _confirmPasswordController,
                hintText: '••••••••',
                obscureText: _obscureConfermPassword,
                suffixIcon: ObscureToggleWidget(
                  obscured: _obscureConfermPassword,
                  onTap: () => setState(
                    () => _obscureConfermPassword = !_obscureConfermPassword,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleCreateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsApp.primary,
                  foregroundColor: ColorsApp.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 1,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: ColorsApp.onPrimary,
                        ),
                      )
                    : Text(
                        'Create Account',
                        style: typography.bodyLG.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorsApp.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter({required TypographyApp typography}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: ColorsApp.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: ColorsApp.outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: typography.bodyMD.copyWith(
              color: ColorsApp.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: "Already have an account? "),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () => Navigator.maybePop(context),
                  child: Text(
                    'Sign In',
                    style: typography.bodyMD.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
