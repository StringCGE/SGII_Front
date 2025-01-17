import 'package:sgii_front/model/cls_000_db_obj.dart';

class ItemList<T extends DbObj>{
  final T value;
  bool _selected = false;
  bool _andSelected = false;
  void Function()? reset;
  bool get selected => _selected;
  set selected(bool value){
    _selected = value;
    if (reset != null){
      if(_andSelected != _selected){
        reset!();
      }
    }
    _andSelected = _selected;
  }
  ItemList({
    required this.value,
  });

}