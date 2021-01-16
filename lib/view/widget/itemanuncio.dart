import 'package:flutter/material.dart';
import 'package:oxl/model/anuncio.dart';

class ItemAnuncio extends StatelessWidget {
  Anuncio anuncio;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemAnuncio({@required this.anuncio, this.onPressedRemover, this.onTapItem});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.network(
                    anuncio.fotos[0],
                    fit: BoxFit.cover,
                  )),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anuncio.titulo,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("R\${anuncio.preco}")
                      ],
                    ),
                  ),
                  flex: 3),
              if (this.onPressedRemover != null)
                Expanded(
                    child: FlatButton(
                      color: Colors.red,
                      padding: EdgeInsets.all(10),
                      onPressed: this.onPressedRemover,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    flex: 1)
            ],
          ),
        ),
      ),
    );
  }
}
