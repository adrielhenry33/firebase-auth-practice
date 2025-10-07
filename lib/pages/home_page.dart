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

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserId() async {
    //faz um get na coleção criada buscando todos os usuarios cadastrados nesta chave
    //pelas regras que geramos no cloud não é possivel ler toda a coleção de uma vez so
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_user.uid)
        .get();
  }

  Future <void> _deleteUser()async{
    try {

      FirebaseFirestore.instance.collection('usuarios').doc(_user.uid).delete();
      
    }on FirebaseAuthException  {
      _showErrorDialog('Não foi possivel deletar o usuario, pois ele não existe');
    } catch (e){
      _showErrorDialog("Erro desconhecido entre em contato com o fornecedor $e" );
    }

  }

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você esta logado como ${_user.email}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),

            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _getUserId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Erro ao carregar os dados do perfil');
                }
                if (snapshot.hasData) {
                  final user = snapshot.data!.data();
                  final nome = user?['Nome'] ?? 'Usuario';
                  final sobrenome = user?['Sobrenome'] ?? 'desconhecido';
                  final idade = user?['Idade']?? 0; 
                  return Card.filled(
                    margin: EdgeInsets.all(15),
                    color: Colors.grey.shade100,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 80,
                        horizontal: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Bem vindo $nome!'),
                          Text('Confira seus dados abaixo:'),
                          Text('Sobrenome: $sobrenome'),
                          Text('Idade: $idade')
                        ],
                      ),
                    ),
                  );
                }
                return Text('Usuario não encontrado');
              },
            ),

            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple[200],
              child: Text('Deslogar'),
            ),

            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.red,
              child: Text('Excluir conta'),
            ),
          ],
        ),
      ),
    );
  }
}
