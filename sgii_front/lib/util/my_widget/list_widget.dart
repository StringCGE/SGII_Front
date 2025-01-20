
import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/result.dart';

class ListWidget<T extends DbObj> extends StatefulWidget {

  final Widget Function(BuildContext context, ItemList<T> item) itemCard;
  final Future<ResultOf<List<T>>> Function(DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) fetchData;

  ListWidget({
    super.key,
    required this.itemCard,
    required this.fetchData,
  });
  @override
  ListWidgetState<T> createState() => ListWidgetState<T>();
}

class ListWidgetState<T extends DbObj> extends State<ListWidget> {
  List<ItemList<T>> lItems = [];
  bool isLoading = false;
  int take = 20;
  DateTime fecha = DateTime.now();
  int lastVisibleIndex = 0;

  Future<void> reset() async{
    lItems.clear();
    isLoading = false;
    fecha = DateTime.now();
    fetchData(fecha, take);
  }
  double currentPosition = 0;
  Future<void> resetGuardaPosLista() async{
    int visibleIndex = lItems.length;
    visibleIndex = visibleIndex > take?visibleIndex:take;
    setState(() {
      lItems.clear();
      isLoading = false;
      fecha = DateTime.now();
    });
    await fetchData(fecha, visibleIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(currentPosition);
    });
  }

  Future<void> fetchData(DateTime offset, int take) async {
    Info info = Info();
    try{
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      ResultOf<List<T>> result = await widget.fetchData(offset, take, false, reset) as ResultOf<List<T>>;
      if (result.success){
        setState(() {
          List<ItemList<T>> itemList = result.value!.map((item) => ItemList<T>(value: item)).toList();
          lItems.addAll(itemList);
          isLoading = false;
          if (lItems.length > 0){
            fecha = lItems.last.value.dtReg;
          }
        });
      }else{
        await info.showMsgDialogAsync(context, "Errror # fetchData", "A fallado el fetch");
      }
    }catch(e){
      await info.showMsgDialogAsync(context, "Errror # fetchData", "Fallo grave en fetch");
    }

  }

  @override
  void initState() {
    super.initState();
    fetchData(fecha, take);
  }
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        currentPosition = _scrollController.position.pixels;
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
          fetchData(fecha, take);
        }
        return false;
      },
      child: ListView.builder(
        itemCount: lItems.length + (isLoading ? 1 : 0),
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index == lItems.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final item = lItems[index];
          return widget.itemCard(context, item);
        },
      ),
    );
  }

}