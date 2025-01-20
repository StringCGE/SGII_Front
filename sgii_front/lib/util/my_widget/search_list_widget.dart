import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';

class SearchListWidget<T extends DbObj> extends StatefulWidget {

  final Widget Function(BuildContext searchListWidgetContext, ItemList<T> item) itemCard;
  final Future<ResultOf<List<T>>> Function(DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) fetchData;
  final List<Widget> Function(BuildContext context) finds;
  final Future<Result> Function(BuildContext context) create;

  const SearchListWidget({
    super.key,
    required this.itemCard,
    required this.fetchData,
    required this.finds,
    required this.create,
  });

  @override
  SearchListWidgetState<T> createState() => SearchListWidgetState<T>();
}

class SearchListWidgetState<T extends DbObj> extends State<SearchListWidget> {
  final GlobalKey<ListWidgetState> _listWidgetKey = GlobalKey<ListWidgetState>();
  String? findNombre;

  void reset(){
    _listWidgetKey.currentState?.reset();
  }
  void resetGuardaPosLista(){
    _listWidgetKey.currentState?.resetGuardaPosLista();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.finds(context),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: (){
                  _listWidgetKey.currentState?.reset();
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await widget.create(context);
                  _listWidgetKey.currentState?.reset();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListWidget(
              key: _listWidgetKey,
              itemCard: widget.itemCard,
              fetchData: widget.fetchData,
            ),
          )
        ],
      ),
    );
  }
}