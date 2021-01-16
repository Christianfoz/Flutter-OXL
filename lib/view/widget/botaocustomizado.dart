import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  BotaoCustomizado(
      {@required this.texto, this.corTexto = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Color(0xff9c27b0),
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          this.texto,
          style: TextStyle(color: this.corTexto),
        ),
        onPressed: () {
          this.onPressed;
        });
  }
}
