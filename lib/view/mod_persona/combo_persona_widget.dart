import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboPersonaWidget extends StatefulWidget {
  Persona? Function() getItem;
  void Function(Persona? item) setItem;
  ComboPersonaWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboPersonaWidgetState createState() => ComboPersonaWidgetState();
}

class ComboPersonaWidgetState extends State<ComboPersonaWidget> {
  final TextEditingController _personaController = TextEditingController();
  Persona personaSelect = Persona.empty();
  PersonaService servPersona = PersonaService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _personaController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Persona? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Persona>(
      labelText: 'Persona',
      hintText: 'Seleccione el Persona',
      controller: _personaController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Persona;
        widget.setItem(value);
        _personaController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Persona item = item_.value as Persona;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Persona aux = value!;
          if (aux.idApi > 0){//Aqui posible bug
            if (aux.idApi == item.idApi){
              backColor = Colors.blueAccent;
            }
          }else{
            if (aux.idApi == item.idApi){
              backColor = Colors.blueAccent;
            }
          }
        }
        return Container(
          padding: EdgeInsets.all(8),
          color: backColor,
          child: Text(item.getValueStr()),
        );
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<Persona>> result = await servPersona.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
