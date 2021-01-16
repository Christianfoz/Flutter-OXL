import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {
  static List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> itensDropCategorias = [];
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Categoria"), value: null));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Automoveis"), value: "Auto"));
    itensDropCategorias
        .add(DropdownMenuItem(child: Text("Moveis"), value: "Movel"));

    return itensDropCategorias;
  }

  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> itensDropEstados = [];
    itensDropEstados.add(DropdownMenuItem(child: Text("Regiao"), value: null));
    for (var estado in Estados.listaEstadosSigla) {
      itensDropEstados
          .add(DropdownMenuItem(child: Text(estado), value: estado));
    }

    return itensDropEstados;
  }
}
