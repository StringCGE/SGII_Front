

import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';

class PickListWidget<T extends DbObj> extends StatefulWidget {

  final String labelText;
  final String hintText;
  final String? Function(String?) validator;

  final Widget Function(BuildContext pickListWidget, Future<void> Function() onSetState) filterList;
  final Widget Function(BuildContext pickListWidget, ItemList<T> item) selectedItemCard;

  final List<ItemList<DbObj>> lItemPickList;

  PickListWidget({
    super.key,
    required this.lItemPickList,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.filterList,
    required this.selectedItemCard,
  });

  @override
  _PickListWidgetState<T> createState() => _PickListWidgetState<T>();
}

class _PickListWidgetState<T extends DbObj> extends State<PickListWidget> {

  void _selectItem(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (showDialogContext) {
        return AlertDialog(
          title: Text('Seleccionar'),
          content: Container(
            width: 500,
            child: Column(
              children: [
                Expanded(
                  child: widget.filterList(context, () async {
                    setState(() {});
                  }),
                ),
                Wrap(
                  children: [
                    Padding(padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed:  (){
                          Navigator.of(showDialogContext).pop();
                        },
                        child: Text("Aceptar"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    Padding(padding:
                    EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(showDialogContext).pop();
                        },
                        child: Text("Cancelar"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        );
      }
    );
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.labelText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectItem(context),
                child: const Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Reemplazamos el TextFormField por un ListView dentro de un Container con borde
          Container(
            height: 150, // Fija la altura del ListView
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Borde redondeado
              border: Border.all(color: Colors.grey), // Borde gris alrededor
            ),
            child: ListView.builder(
              itemCount: widget.lItemPickList.length, // Número de elementos en la lista
              itemBuilder: (context, index) {
                return widget.selectedItemCard(context, widget.lItemPickList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PickWidget<T extends DbObj> extends StatefulWidget {

  final String labelText;
  final String hintText;
  final String? Function(String?) validator;

  final Widget Function(BuildContext pickListWidget, Future<void> Function() onSetState) filterList;
  final Widget Function(BuildContext pickListWidget, ItemList<T> item) selectedItemCard;
  final double labelWidth;

  final List<ItemList<DbObj>> lItemPickList;

  PickWidget({
    super.key,
    required this.lItemPickList,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.filterList,
    required this.selectedItemCard,
    this.labelWidth = 100,
  });

  @override
  _PickWidgetState<T> createState() => _PickWidgetState<T>();
}

class _PickWidgetState<T extends DbObj> extends State<PickWidget> {

  void _selectItem(BuildContext context) async {
    await showDialog<String>(
        context: context,
        builder: (showDialogContext) {
          return AlertDialog(
            title: Text('Seleccionar'),
            content: Container(
                width: 500,
                child: Column(
                  children: [
                    Expanded(
                      child: widget.filterList(context, () async {
                        setState(() {});
                      }),
                    ),
                    Wrap(
                      children: [
                        Padding(padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed:  (){
                              Navigator.of(showDialogContext).pop();
                            },
                            child: Text("Aceptar"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ),
                        Padding(padding:
                        EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.of(showDialogContext).pop();
                            },
                            child: Text("Cancelar"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
            ),
          );
        }
    );
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
      ),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Asegura que los elementos estén centrados
        children: [
          SizedBox(
            width: widget.labelWidth,
            child: Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 16, // Tamaño más pequeño
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis, // Oculta texto que sobresale
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _selectItem(context),
              child: const Icon(
                Icons.list,
                color: Colors.grey,
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 50, // Altura fija para el TextFormField
              child: Container(
                height: 150, // Fija la altura del ListView
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // Borde redondeado
                  border: Border.all(color: Colors.grey), // Borde gris alrededor
                ),
                child: ListView.builder(
                  itemCount: widget.lItemPickList.length, // Número de elementos en la lista
                  itemBuilder: (context, index) {
                    return widget.selectedItemCard(context, widget.lItemPickList[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.labelText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectItem(context),
                child: const Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Reemplazamos el TextFormField por un ListView dentro de un Container con borde
          Container(
            height: 150, // Fija la altura del ListView
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Borde redondeado
              border: Border.all(color: Colors.grey), // Borde gris alrededor
            ),
            child: ListView.builder(
              itemCount: widget.lItemPickList.length, // Número de elementos en la lista
              itemBuilder: (context, index) {
                return widget.selectedItemCard(context, widget.lItemPickList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
/*
GestureDetector(
  onTap: () => _selectItem(context),
  child: const Icon(
    Icons.list,
    color: Colors.grey,
  ),
),
* */




class PickList01Widget<T extends DbObj> extends StatefulWidget {

  final String labelText;
  final String hintText;
  final String? Function(String?) validator;

  final Widget Function(BuildContext pickListWidget, Future<void> Function() onSetState) filterList;
  final Widget Function(BuildContext pickListWidget, ItemList<T> item) selectedItemCard;

  final List<ItemList<DbObj>> lItemPickList;
  final void Function(BuildContext context) selectItem;

  PickList01Widget({
    super.key,
    required this.lItemPickList,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.filterList,
    required this.selectedItemCard,
    required this.selectItem,
  });

  @override
  _PickList01WidgetState<T> createState() => _PickList01WidgetState<T>();
}

class _PickList01WidgetState<T extends DbObj> extends State<PickList01Widget> {



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.labelText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => widget.selectItem(context),
                child: const Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Reemplazamos el TextFormField por un ListView dentro de un Container con borde
          Container(
            height: 320, // Fija la altura del ListView
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Borde redondeado
              border: Border.all(color: Colors.grey), // Borde gris alrededor
            ),
            child: ListView.builder(
              itemCount: widget.lItemPickList.length, // Número de elementos en la lista
              itemBuilder: (context, index) {
                return widget.selectedItemCard(context, widget.lItemPickList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}