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

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserId() async {
    //faz um get na coleção criada buscando todos os usuarios cadastrados nesta chave
    //pelas regras que geramos no cloud não é possivel ler toda a coleção de uma vez so
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_user.uid)
        .get();
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
                  final nome = user?['Nome'];
                  final sobrenome = user?['Sobrenome'];
                  final idade = user?['Idade'];
                  final email = user?['email'];
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
          ],
        ),
      ),
    );
  }
}
