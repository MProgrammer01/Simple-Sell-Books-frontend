import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sell_your_books/Core/Values/colors.dart';
import 'package:sell_your_books/Core/Values/strings.dart';
import 'package:sell_your_books/Core/Values/typography.dart';
import 'package:sell_your_books/Features/Auth/Widgets/label_widget.dart';
import 'package:sell_your_books/Features/Auth/Widgets/text_field_widget.dart';
import 'package:sell_your_books/Features/Auth/cubit/auth_cubit.dart';
import 'package:sell_your_books/Features/Auth/data/auth_dtos.dart';
import 'package:sell_your_books/Features/global/data/storage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final signInDTO = ClsSignInDTO(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    context.read<AuthCubit>().signIn(signInDTO);
  }

  void _notImplementedYet(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("This feature is not implemented yet: $message")),
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyApp>()!;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          final response = state.response;

          print("accessToken : ${response.accessToken}");
          print("refreshToken : ${response.refreshToken}");

          ClsStorage.saveInfos(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            email: response.email,
            personID: response.personID
            // personID: response.personID,
          );

          Navigator.pushReplacementNamed(context, ClsStingsApp.dashboardScreen);
        } else if (state is SignInInvalidCredentials) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email or password is incorrect')),
          );
        } else if (state is SignInTooManyRequests) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Too many attempts. Try again later.'),
            ),
          );
        } else if (state is SignInFailure) {
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
        // , required bool isLoading
        return Scaffold(
          body: Center(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context)
                  .copyWith(scrollbars: false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsApp.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorsApp.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorsApp.outlineVariant.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ColorsApp.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: ColorsApp.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Simple Sell Books',
            textAlign: TextAlign.center,
            style: typography.headlineLG.copyWith(
              letterSpacing: -0.24,
              color: ColorsApp.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to your account',
            textAlign: TextAlign.center,
            style: typography.bodyMD.copyWith(
              color: ColorsApp.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm({required TypographyApp typography}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelWidget(
              text: 'Email Address',
              color: ColorsApp.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            TextFieldWidget(
              controller: _emailController,
              hint: 'you@example.com',
              prefixIcon: Icon(
                Icons.mail_outline,
                size: 20,
                color: ColorsApp.outline,
              ),
              keyboardType: TextInputType.emailAddress,
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
            const SizedBox(height: 24),
            LabelWidget(text: 'Password', color: ColorsApp.onSurfaceVariant),
            const SizedBox(height: 8),
            TextFieldWidget(
              controller: _passwordController,
              hint: '••••••••',
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 20,
                color: ColorsApp.outline,
              ),
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: ColorsApp.outline,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? false);
                            _notImplementedYet('Remember Me');
                          },
                          activeColor: ColorsApp.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember me',
                        style: typography.bodyMD.copyWith(
                          color: ColorsApp.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _notImplementedYet('Forgot password');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: typography.labelSM.copyWith(
                      color: ColorsApp.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSignIn,
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
                        'Sign In',
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
          top: BorderSide(color: ColorsApp.outlineVariant.withOpacity(0.3)),
        ),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: typography.bodyMD.copyWith(
              color: ColorsApp.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: "Don't have an account? "),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, ClsStingsApp.signUpScreen),
                  child: Text(
                    'Sign Up',
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
