import 'package:flutter/material.dart';

class MainModuleCargo extends StatefulWidget {

  MainModuleCargo({
    super.key,
  });

  @override
  MainModuleCargoState createState() => MainModuleCargoState();
}

class MainModuleCargoState extends State<MainModuleCargo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleCargo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const Row(
              children: [
                Column(
                  children: [
                    Text("Cargo"),
                    Text("Permite administrar las opciones para el campo sexo en otras areas"),
                    Text("Cargo: es uan clasificacion del ser humano, mas no la orientacion sexual"),
                  ],
                )
              ],
            ),
            Expanded(
              child: FilterListCargoWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }

}