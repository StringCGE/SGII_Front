import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Info{

  void toastFlotante(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade400,),
              const SizedBox(width: 20,),
              const Text('Error')
            ],
          ),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
  void showMsgDialog(BuildContext context,String titulo, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
  Future<void> showErrorDialogAsync(BuildContext context, String errorMessage) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red.shade400,
              ),
              const SizedBox(width: 20),
              const Text('Error'),
            ],
          ),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Muestra un cuadro de diálogo con un mensaje general (ahora es async)
  Future<void> showMsgDialogAsync(BuildContext context, String titulo, String msg) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  BuildContext? _loadingDialogContext;

  Future<void> showLoadingMask(BuildContext context) async {
    if (_loadingDialogContext != null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _loadingDialogContext = context;
        return const Dialog(
          backgroundColor: Colors.transparent, // Fondo transparente
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
  Future<void> hideLoadingMask(BuildContext context) async {
    if (_loadingDialogContext != null) {
      Navigator.of(_loadingDialogContext!, rootNavigator: true).pop();
      _loadingDialogContext = null;
    }
  }
}