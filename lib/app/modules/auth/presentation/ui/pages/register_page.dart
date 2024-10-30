import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/shared/ui/widgets/app_button.dart';
import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthBloc authBloc = autoInjector<AuthBloc>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String firstName = _firstNameController.text.trim();
      final String lastName = _lastNameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas não coincidem.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      authBloc.add(
        AuthRegisterButtonPressed(
          firstName: firstName,
          lastName: lastName,
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
              padding: const EdgeInsets.all(Spacing.defaultSpacing * 2),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo_to_liso.png",
                      width: 160,
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
                    Text(
                      "Registro",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: Spacing.defaultSpacing * 2),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira seu nome.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Sobrenome',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira seu sobrenome.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira sua senha.';
                        }
                        if (value.trim().length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirme a Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, confirme sua senha.';
                        }
                        if (value.trim() != _passwordController.text.trim()) {
                          return 'As senhas não coincidem.';
                        }
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
                              name: "REGISTRAR",
                              padding:
                                  const EdgeInsets.all(Spacing.defaultSpacing),
                              buttonColor: Colors.teal[600]!,
                              shadowColor: Colors.teal[800]!,
                              icon: Icons.check_circle_outline,
                              onTap: _submitForm,
                            ),
                    ),
                    const SizedBox(height: Spacing.defaultSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Já tem uma conta? "),
                        GestureDetector(
                          onTap: () {
                            context.go("/login");
                          },
                          child: Text(
                            "Faça Login",
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
