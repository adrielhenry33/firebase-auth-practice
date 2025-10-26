import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_backend/components/text_field_component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _senhaConfirmController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _idadeController = TextEditingController();

  Future _signUp() async {
    if (!_passowordConfirmed()) return;

    int idadeUser = 0;
    try {
      idadeUser = int.parse(_idadeController.text.trim());
    } on FormatException {
      _showErrorDialog(
        'Idade invalida!',
        'Por favor so infome numeros no campo de idade',
      );
      return;
    }

    try {
      final UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _senhaController.text.trim(),
          );

      final uid = user.user?.uid;

      if (uid != null) {
        await _addUserDetails(
          _nomeController.text.trim(),
          _sobrenomeController.text.trim(),
          _emailController.text.trim(),
          idadeUser,
          uid,
        );
      }
      widget.showLoginPage();
    } on FirebaseAuthException catch (e) {
      String titulo = 'Erro de Autenticação';
      String conteudo = 'Ocorreu um erro desconhecido.';

      if (e.code == 'invalid-email') {
        conteudo =
            'O formato do e-mail é inválido. Verifique se digitou corretamente.';
      } else if (e.code == 'weak-password') {
        conteudo =
            'A senha fornecida é muito fraca. Use no mínimo 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        conteudo = 'Este e-mail já está em uso. Tente fazer login.';
      }

      _showErrorDialog(titulo, conteudo);
    }
  }

  bool _passowordConfirmed() {
    if (_senhaController.text.trim().length < 6) {
      _showErrorDialog(
        'Senha',
        'Senha invalida por favor informe uma senha com no minimo 6 digitos',
      );
      return false;
    }

    if (_senhaController.text.trim() == _senhaConfirmController.text.trim()) {
      return true;
    }
    _showErrorDialog('Erro', 'Senhas não são iguais tente novamente');
    return false;
  }

  Future<void> _addUserDetails(
    String nome,
    String sobrenome,
    String email,
    int idade,
    String uid,
  ) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'Email': email,
      'Idade': idade,
      'Nome': nome,
      'Sobrenome': sobrenome,
      'DataDaCriacao': FieldValue.serverTimestamp(),
    });
  }

  void _showErrorDialog(String texto, String conteudo) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(texto),
          content: Text(conteudo),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaConfirmController.dispose();
    _senhaController.dispose();
    _idadeController.dispose();
    _sobrenomeController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.android, size: 100),
                SizedBox(height: 75),
                Text('Olá!', style: GoogleFonts.bebasNeue(fontSize: 52)),
                SizedBox(height: 15),
                Text('Registre-se Abaixo!', style: TextStyle(fontSize: 20)),
                SizedBox(height: 50),

                TextFieldComponent(
                  controller: _nomeController,
                  dica: 'Nome',
                  isObscured: false,
                ),
                SizedBox(height: 15),

                TextFieldComponent(
                  controller: _sobrenomeController,
                  dica: 'Sobrenome',
                  isObscured: false,
                ),
                SizedBox(height: 15),

                TextFieldComponent(
                  controller: _idadeController,
                  dica: 'Idade',
                  isObscured: false,
                ),
                SizedBox(height: 15),

                TextFieldComponent(
                  controller: _emailController,
                  dica: 'Email',
                  isObscured: false,
                ),
                SizedBox(height: 15),

                TextFieldComponent(
                  controller: _senhaController,
                  dica: 'Senha',
                  isObscured: true,
                ),
                SizedBox(height: 15),

                TextFieldComponent(
                  controller: _senhaConfirmController,
                  dica: 'Confirme sua Senha',
                  isObscured: true,
                ),

                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: _signUp,
                    child: Container(
                      padding: EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Cadastrar-se',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já é membro? ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => widget.showLoginPage(),

                      child: Text(
                        'Faça login aqui!',
                        style: TextStyle(
                          color: Colors.blue,
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
      ),
    );
  }
}
