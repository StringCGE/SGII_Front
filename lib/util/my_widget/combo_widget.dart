import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';

class ComboWidget<T extends DbObj> extends StatefulWidget {

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  final Function(ItemList<T> item) onSelectedItem;

  final Widget Function(BuildContext context, ItemList<T> item) itemCard;
  final Future<ResultOf<List<T>>> Function(DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) fetchData;

  ComboWidget({
    super.key,
    required this.onSelectedItem,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.itemCard,
    required this.fetchData,
  });

  @override
  _ComboWidgetState<T> createState() => _ComboWidgetState<T>();
}

class _ComboWidgetState<T extends DbObj> extends State<ComboWidget> {
  final GlobalKey<ListWidgetState> _listWidgetKey = GlobalKey<ListWidgetState>();
  void _selectItem(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (showDialogContext) {
        return AlertDialog(
          title: const Text('Agregar Persona'),
          content: Container(
            width: 500,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListWidget(
                    key: _listWidgetKey,
                    itemCard: (BuildContext context, ItemList<DbObj> item_) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.pop(showDialogContext);
                          //Navigator.popUntil(showDialogContext, (route) => route.isFirst);
                          widget.onSelectedItem(item_);
                        },
                        child: widget.itemCard(context, item_),
                      );
                    },
                    fetchData: widget.fetchData,
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50], // Fondo celeste
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Sombra suave
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey), // Borde interno gris
              ),
              suffixIcon: GestureDetector(
                onTap: () => _selectItem(context),
                child: const Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
            ),
            readOnly: true,
            onTap: () => _selectItem(context),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}