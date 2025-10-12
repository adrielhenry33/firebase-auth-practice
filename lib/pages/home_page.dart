import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _user = FirebaseAuth.instance.currentUser!;
  bool _isSelected = false;
  TextEditingController? _senhaController;
  TextEditingController? _emailController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Você esta logado como ${_user.email}'),

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _isSelected = true;
                    });
                  },
                  color: Colors.red,
                  child: Text('Deletar usuario'),
                ),
                SizedBox(width: 10,),
                MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  color: Colors.deepPurple[200],
                  child: Text('Deslogar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
