import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oxl/model/usuario.dart';
import 'package:oxl/view/widget/botaocustomizado.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _email;
  String _senha;
  bool _switch = false;
  String _textoBotao = "Entrar";

  _validarCampos() {
    _email = _emailController.text.toString();
    _senha = _emailController.text.toString();
    if (_email.isEmpty || _senha.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK"))
            ],
            content: Container(
              padding: EdgeInsets.all(4),
              child: Text("Um ou mais dados precisam ser inseridos"),
            ),
            contentPadding: EdgeInsets.all(16),
            title: Text("Erro"),
          );
        },
      );
    } else {
      Usuario u = Usuario();
      u.email = _email;
      u.senha = _senha;
      if (!_switch) {
        _logarUsuario(u);
      } else {
        _cadastrarUsuario(u);
      }
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    auth.createUserWithEmailAndPassword(email: _email, password: _senha);
    Navigator.pushReplacementNamed(context, "/");
  }

  _logarUsuario(Usuario usuario) {
    auth.signInWithEmailAndPassword(email: _email, password: _senha);
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9c27b0),
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Image.asset(
                      "imagens/logo.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _senhaController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        hintText: "Senha",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Logar"),
                      Switch(
                          value: _switch,
                          onChanged: (status) {
                            setState(() {
                              _switch = status;
                              if (_switch) {
                                _textoBotao = "Cadastrar";
                              } else {
                                _textoBotao = "Entrar";
                              }
                            });
                          }),
                      Text("Cadastrar")
                    ],
                  ),
                  BotaoCustomizado(
                    texto: _textoBotao,
                    onPressed: _validarCampos(),
                  ),
                  /*
                  RaisedButton(
                      color: Color(0xff9c27b0),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        _textoBotao,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                      */
                ],
              ),
            ),
          )),
    );
  }
}
