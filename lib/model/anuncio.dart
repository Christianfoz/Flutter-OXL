import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String _id;
  String _titulo;
  String _descricao;
  String _estado;
  String _categoria;
  String _telefone;
  List<String> _fotos;
  String _preco;

  Anuncio.gerarId() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus-anuncios");
    this.id = anuncios.doc().id;
    this.fotos = [];
  }

  Anuncio.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.titulo = snapshot["titulo"];
    this.descricao = snapshot["descricao"];
    this.estado = snapshot["estado"];
    this.categoria = snapshot["categoria"];
    this.telefone = snapshot["telefone"];
    this.preco = snapshot["preco"];
    this.fotos = List<String>.from(snapshot["fotos"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "titulo": this.titulo,
      "descricao": this.descricao,
      "estado": this.estado,
      "categoria": this.categoria,
      "telefone": this.telefone,
      "preco": this.preco,
      "fotos": this.fotos
    };
    return map;
  }

  String get id => _id;

  set id(String value) => _id = value;

  String get titulo => _titulo;

  set titulo(String value) => _titulo = value;

  String get telefone => _telefone;

  set telefone(String value) => _telefone = value;

  String get descricao => _descricao;

  set descricao(String value) => _descricao = value;

  String get estado => _estado;

  set estado(String value) => _estado = value;

  String get categoria => _categoria;

  set categoria(String value) => _categoria = value;

  List<String> get fotos => _fotos;

  set fotos(List<String> value) => _fotos = value;

  String get preco => _preco;

  set preco(String value) => _preco = value;
}
