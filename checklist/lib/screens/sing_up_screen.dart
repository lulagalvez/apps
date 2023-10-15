import 'package:flutter/material.dart';
import 'package:checklist/users.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class MyFormSingUp extends StatefulWidget {
  const MyFormSingUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyFormSingUp> {
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _signupUsernameController =
      TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
      TextEditingController();
  final TextEditingController _signupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  bool _isPasswordVisible = false, _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _signupUsernameController,
                decoration: const InputDecoration(
                    labelText: 'Usuario', hintText: 'Ej: Example1'),
                validator: Validators.compose([
                  Validators.required('Nombre de usuario requerido'),
                  Validators.patternRegExp(
                      RegExp(r'^[0-9a-zA-Z]+$'), 'Nombre de usuario inválido')
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _signupPasswordController,
                decoration: InputDecoration(
                  hintText: 'Ej: SafePassword1',
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: Validators.compose([
                  Validators.required('Contraseña requerida'),
                  Validators.patternString(
                      r'^[0-9a-zA-Z]+$', 'Contraseña inválida')
                ]),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _signupConfirmPasswordController,
                decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    )),
                obscureText: !_isConfirmPasswordVisible,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _signupNameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: Validators.required('Nombre requerido')),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _handleSignup(context);
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String username = _signupUsernameController.text;
      String password = _signupPasswordController.text;
      String confirmPassword = _signupConfirmPasswordController.text;
      String name = _signupNameController.text;
      if (password == confirmPassword) {
        if (!_userRepository.isUsernameTaken(username)) {
          _userRepository.registerUser(username, password, name);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Registro Exitoso'),
                content: Text('¡Bienvenido, $name! Tu cuenta ha sido creada.'),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', ModalRoute.withName('/'),
                            arguments: name);
                        print('$name ESTE ES EL PRINT');
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'El nombre de usuario ya está en uso. Por favor, elige otro.'),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Las contraseñas no coinciden, mostrar mensaje de error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Las contraseñas no coinciden. Por favor, inténtalo de nuevo.'),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
