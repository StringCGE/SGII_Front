import 'package:flutter/material.dart';
import 'package:sgii_front/model/estado.dart';
import 'package:sgii_front/util/my_widget/main_logon_widget.dart';
import 'package:sgii_front/util/my_widget/menu_opcions.dart';

class WebLoginScreen extends StatefulWidget {
  @override
  WebLoginScreenState createState() => WebLoginScreenState();
}

class WebLoginScreenState extends State<WebLoginScreen> {
  final tecUser = TextEditingController();
  final tecPsw = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  color: Estado().appStyle.webColorLoginBack,
                  child: Center(
                    child: Container(
                      width: 440, // Establece el ancho del contenedor
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Estado().appStyle.webColorLoginBox,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // Cambia la posición de la sombra
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: tecUser,
                              decoration: InputDecoration(
                                labelText: 'Usuario',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu usuario';
                                }
                                /*if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }*/
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: tecPsw,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainLogonWidget(
                                      menuOptions: MenuOptions(),
                                      child: Text("Hoooola"),
                                    ),
                                  ),
                                );
                                /*Estado().cLogin.loginAdmin(
                                    context: context,
                                    user: tecUser.text,
                                    psw: tecPsw.text,
                                    onLogin: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainLogonWidget(
                                              menuOptions: MenuOptions(),
                                              child: Text("Hoooola"),
                                          ),
                                        ),
                                      );
                                      /*Nav.navDropAll(
                                          context: context,
                                          next: () => HomeWebScreen(),
                                          settingName: 'HomeWebScreen',
                                          settingArg: null
                                      );*/
                                    }
                                );*/
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Estado().appStyle.webColorLoginButton,
                                foregroundColor: Estado().appStyle.webColorLoginButtonForeground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                //padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text('Login'),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  /*Nav.push(
                                      context: context,
                                      next: () => PswRecovery01AndroidScreen(),
                                      settingName: 'PswRecovery01AndroidScreen',
                                      settingArg: null
                                  );*/
                                },
                                child: Text(
                                  'Olvidaste tu contraseña',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  /*Nav.push(
                                      context: context,
                                      next: () => PswRecovery01AndroidScreen(),
                                      settingName: 'PswRecovery01AndroidScreen',
                                      settingArg: null
                                  );*/
                                },
                                child: Text(
                                  'Nuevo Usuario',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              )
          ),
          Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon:Icon(Icons.close, size: 30, color: Colors.black,),
                onPressed: (){
                  /*try{
                  Nav.navPop(context: context);
                }catch(e){*/
                  /*Nav.push(
                      context: context,
                      next: () => StartWebScreen(),
                      settingName: 'StartWebScreen',
                      settingArg: null
                  );*/
                  //}
                },
              )
          ),
        ],
      ),
    );
  }
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impide que el usuario cierre el diálogo tocando fuera de él
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Fondo del diálogo transparente
          child: Center(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Fondo semitransparente
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Color del indicador
              ),
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Opción alternativa si tienes múltiples diálogos:
    // Navigator.of(context).pop();
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impide que el usuario cierre el diálogo tocando fuera de él
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
              SizedBox(width: 10),
              Text('Inicio de sesión fallido'),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 40,
              ),
              SizedBox(width: 10),
              Text('Ha fallado el inicio de sesión.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de error
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}