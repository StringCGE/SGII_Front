class ErrrorNotify{
  String name;
  String msg;
  bool errrorExist;
  ErrrorNotify({
    required this.name,
    required this.msg,
    this.errrorExist = true,
  });
}
class ListErrror{
  List<ErrrorNotify> lErr = [];
  void add(ErrrorNotify value){
    lErr.add(value);
  }
  void clear(){
    lErr.clear();
  }
  ErrrorNotify? find(String name){
    for (ErrrorNotify element in lErr) {
      if (element.name == name) return element;
    }
    return null;
  }

  bool get haveErrror => lErr.length > 0;
}