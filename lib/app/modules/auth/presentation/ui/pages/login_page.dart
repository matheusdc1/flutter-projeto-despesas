import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/modules/shared/ui/widgets/app_button.dart';
import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc authBloc = autoInjector<AuthBloc>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      authBloc.add(
        AuthLoginButtonPressed(
          email: email,
          password: password,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go("/home");
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.defaultSpacing),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(width: 160, "assets/images/logo_to_liso.png"),
                    const SizedBox(height: Spacing.defaultSpacing),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: Spacing.defaultSpacing * 2),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira seu email.';
                        }
                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
                            r"[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Por favor, insira um email válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Por favor, insira sua senha.';
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.defaultSpacing * 2),
                    SizedBox(
                      width: double.infinity,
                      child: state is AuthLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : AppButton(
                              name: "ENTRAR",
                              padding:
                                  const EdgeInsets.all(Spacing.defaultSpacing),
                              buttonColor: Colors.teal[600]!,
                              shadowColor: Colors.teal[800]!,
                              icon: Icons.login,
                              onTap: () => _submitForm(),
                            ),
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Não tem uma conta? "),
                        GestureDetector(
                          onTap: () {
                            context.go("/register");
                          },
                          child: Text(
                            "Registre-se",
                            style: TextStyle(
                              color: Colors.teal[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
