import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:oxl/model/anuncio.dart';
import 'package:oxl/view/util/configuracoes.dart';
import 'package:oxl/view/widget/botaocustomizado.dart';
import 'package:oxl/view/widget/inputcustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaDropEstados = List();
  //String seria o valor e não o titulo
  List<DropdownMenuItem<String>> _listaDropCategorias = List();
  String _estadoSelecionado = "AM";
  String _categoriaSelecionada = "Auto";
  Anuncio _anuncio;
  BuildContext _dialogContext;

  _selecionarFotoGaleria() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    File imagemSelecionada = File(pickedFile.path);
    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarItensDropdown();
    _anuncio = Anuncio.gerarId();
  }

  _carregarItensDropdown() {
    _listaDropCategorias = Configuracoes.getCategorias();
    _listaDropEstados = Configuracoes.getEstados();
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Salvando")
              ],
            ),
          );
        });
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext);
    await _uploadFotos();
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    String id = user.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus-anuncios")
        .doc(id)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap())
        .then((_) {
      db
          .collection("anuncios")
          .doc(_anuncio.id)
          .set(_anuncio.toMap())
          .then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    });
  }

  Future _uploadFotos() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    for (var imagem in _listaImagens) {
      String nomeArquivo = DateTime.now().microsecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
          .child("meus-anuncios")
          .child(_anuncio.id)
          .child(nomeArquivo);
      StorageUploadTask task = arquivo.putFile(imagem);
      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Anúncio"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormField<List>(
                      initialValue: _listaImagens,
                      validator: (imagens) {
                        if (imagens.length == 0) {
                          return "Necessario selecionar imagem";
                        } else {
                          return null;
                        }
                      },
                      builder: (state) {
                        return Column(
                          children: [
                            Container(
                              height: 100,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  if (index == _listaImagens.length) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () => _selecionarFotoGaleria(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[400],
                                          radius: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo,
                                                  size: 40,
                                                  color: Colors.grey[100]),
                                              Text(
                                                "Adicionar",
                                                style: TextStyle(
                                                    color: Colors.grey[100]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (_listaImagens.length > 0) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.file(
                                                            _listaImagens[
                                                                index]),
                                                        FlatButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _listaImagens
                                                                    .removeAt(
                                                                        index);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            },
                                                            child:
                                                                Text("Excluir"))
                                                      ],
                                                    ),
                                                  ));
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              FileImage(_listaImagens[index]),
                                          child: Container(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.4),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                                itemCount: _listaImagens.length + 1,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            if (state.hasError)
                              Container(child: Text("[${state.errorText}]"))
                          ],
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                              validator: (valor) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                        msg: "Campo Obrigatório")
                                    .valido(valor);
                              },
                              value: _estadoSelecionado,
                              hint: Text("Estados"),
                              items: _listaDropEstados,
                              onSaved: (estado) {
                                _anuncio.estado = estado;
                              },
                              onChanged: (valor) {
                                setState(() {
                                  _estadoSelecionado = valor;
                                });
                              }),
                        )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                              validator: (valor) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                        msg: "Campo Obrigatório")
                                    .valido(valor);
                              },
                              value: _categoriaSelecionada,
                              hint: Text("Categoria"),
                              items: _listaDropCategorias,
                              onSaved: (categoria) {
                                _anuncio.categoria = categoria;
                              },
                              onChanged: (valor) {
                                setState(() {
                                  _categoriaSelecionada = valor;
                                });
                              }),
                        ))
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: InputCustomizado(
                          hint: "Título",
                          onSaved: (titulo) {
                            _anuncio.titulo = titulo;
                          },
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Obrigatório")
                                .valido(valor);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: InputCustomizado(
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            RealInputFormatter(centavos: true)
                          ],
                          hint: "Preço",
                          type: TextInputType.number,
                          onSaved: (preco) {
                            _anuncio.preco = preco;
                          },
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Obrigatório")
                                .valido(valor);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: InputCustomizado(
                          type: TextInputType.phone,
                          hint: "Telefone",
                          onSaved: (telefone) {
                            _anuncio.telefone = telefone;
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Obrigatório")
                                .valido(valor);
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: InputCustomizado(
                          maxLines: null,
                          hint: "Descricao",
                          onSaved: (descricao) {
                            _anuncio.descricao = descricao;
                          },
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Obrigatório")
                                .maxLength(200, msg: "Máximo 200 caracteres")
                                .valido(valor);
                          },
                        )),
                    BotaoCustomizado(
                      texto: "Cadastrar Anúncio",
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //salva campos
                          _formKey.currentState.save();
                          _dialogContext = context;
                          //salva anuncio
                          _salvarAnuncio();
                        }
                      },
                    ),
                  ],
                )),
          ),
        ));
  }
}
