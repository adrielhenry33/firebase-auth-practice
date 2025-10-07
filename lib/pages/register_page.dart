import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    int idade;

    try {
      idade = int.parse(_idadeController.text.trim());
    } catch (e) {
      _showErrorDialog('Idade invalida! Por favor informe apenas numeros');
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _senhaController.text.trim(),
          );
      if (userCredential.user?.uid != null) {
        await _addUserDetails(
          _nomeController.text.trim(),
          _sobrenomeController.text.trim(),
          idade,
          _emailController.text.trim(),
          userCredential.user?.uid,
        );
      }
      
      if(mounted){
        widget.showLoginPage();
      }

    } on FirebaseAuthException catch (e) {
      String mensagemErro = '';
      if (e.code == 'weak-password') {
        mensagemErro = 'Senha fraca por favor informe uma outra senha';
      } else if (e.code == 'email-already-in-use') {
        mensagemErro = "e-mail ja cadastrado";
      } else if (e.code == 'invalid-email') {
        mensagemErro = 'e-mail invalido!, informe outro email';
      }
      _showErrorDialog(mensagemErro);
    } catch (e) {
      _showErrorDialog(
        'Erro desconhecido, não foi possivel realizar o cadastro',
      );
    }
  }

  bool _passowordConfirmed() {
    if (_senhaConfirmController.text.length < 6 ||
        _senhaController.text.length < 6) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Senha invávlida digite pelo menos 6 caracteres'),
          );
        },
      );
      return false;
    }

    if (_senhaConfirmController.text.trim() != _senhaController.text.trim()) {
      _showErrorDialog('Senhas diferentes, digite senhas iguais');
      return false;
    }

    return true;
  }

  Future _addUserDetails(
    String nome,
    String sobrenome,
    int idade,
    String email,
    String? uid,
  ) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'Nome': nome,
      'Sobrenome': sobrenome,
      'Idade': idade,
      'email': email,
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
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
                SizedBox(height: 50),
                Text('Olá!', style: GoogleFonts.bebasNeue(fontSize: 52)),
                SizedBox(height: 15),
                Text('Registre-se Abaixo!', style: TextStyle(fontSize: 20)),
                SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nome',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _sobrenomeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Sobrenome',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _idadeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Idade',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Senha',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _senhaConfirmController,

                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirmar Senha',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () {
                      _signUp();
                    },
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
                      onTap: () {
                        widget.showLoginPage();
                      },
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
