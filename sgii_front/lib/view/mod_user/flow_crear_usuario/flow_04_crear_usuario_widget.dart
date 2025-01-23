import 'dart:math';
import 'package:flutter/material.dart';


class Flow04CrearUsuarioWidget extends StatelessWidget {
  Flow04CrearUsuarioWidget();
  @override
  Widget build(BuildContext context) {
    return buildSuccess(context);
  }
  Widget buildSuccess(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child:  Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 24, right: 24),
                              child: Center(
                                child: Text(
                                  "Se ha registrado con exito",
                                  textAlign: TextAlign.center, // Alineación del texto dentro del widget Text
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 128, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

}

