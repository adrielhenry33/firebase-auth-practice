import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _user = FirebaseAuth.instance.currentUser!;
  final _senhaController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isSelected = false;

  Future<DocumentSnapshot<Map<String, dynamic>>> _userCollection() async {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_user.uid)
        .get();
  }

  Future<void> _reauthenticate() async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: _emailController.text.trim(),
      password: _senhaController.text.trim(),
    );

    try {
      await _user.reauthenticateWithCredential(credential);
      await _deleteAccount(_user.uid);
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao excluir usuario, email ou senha incorretos';
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        mensagem = 'Email ou senha incorretos';
      }
      _showErrorDialog('Erro ao excluir usuario', mensagem);
    }
  }

  Future<void> _deleteAccount(String uid) async {
    if (uid == '') {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).delete();
      await _user.delete();
    } catch (e) {
      _showErrorDialog(
        'Erro ao excluir usuario',
        'Não foi possivel excluir o usuario tente novamente',
      );
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Você esta logado como ${_user.email}'),
            !_isSelected
                ? Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
                  child: Card(
                      elevation: 2,
                      color: Colors.grey[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: _userCollection(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text('Erro ao carregar os dados');
                              }
                              if (snapshot.hasData) {
                                final user = snapshot.data!.data();
                                final nome = user?['Nome'] ?? 'Usuario';
                                final sobreome =
                                    user?['Sobrenome'] ?? 'desconhecido';
                                final idade = user?['Idade'] ?? 0;
                                return Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    vertical: 80,
                                    horizontal: 40,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Bem vindo $nome'),
                                      Text('Sobrenome: $sobreome'),
                                      Text('Idade: $idade'),
                                    ],
                                  ),
                                );
                              }
                              return Text('Usuario não encontrado');
                            },
                          ),
                        ],
                      ),
                    ),
                )
                : SizedBox(),
            !_isSelected
                ? MaterialButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    color: Colors.deepPurple[200],
                    child: Text('Deslogar'),
                  )
                : SizedBox(),
            !_isSelected
                ? MaterialButton(
                    onPressed: () {
                      setState(() {
                        _isSelected = true;
                      });
                    },
                    color: Colors.red,
                    child: Text('Deletar usuario'),
                  )
                : SizedBox(height: 15),

            SizedBox(height: 15),

            _isSelected
                ? Column(
                    children: [
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
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'email',
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
                    ],
                  )
                : SizedBox(),

            SizedBox(height: 15),
            _isSelected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _isSelected = true;
                          });
                          if (_emailController.text.trim().isEmpty ||
                              _senhaController.text.trim().isEmpty) {
                            _showErrorDialog(
                              'Campos vazios',
                              'Por favor preencha os campos para prosseguir com a ação.',
                            );
                          } else {
                            _reauthenticate();
                          }
                        },
                        color: Colors.red,
                        child: Text('Deletar usuario'),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        color: Colors.deepPurple[200],
                        child: Text('Deslogar'),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
