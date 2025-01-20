import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sgii_front/util/common/parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/config.dart';

import 'package:sgii_front/model/cls_user.dart';

class UserService {
  static final UserService _singleton = UserService._internal();
  static const String _cacheKey = 'value_cache_User';

  List<User> _lItem = [];

  UserService._internal();

  factory UserService() {
    return _singleton;
  }

  List<User> get lItem => _lItem;
  Future<User> directGetItemById(int id, int idApi) async {
    ResultOf<User> result = await getItemById(id, idApi);
    if (!result.success){
      return User.empty();
    }
    if (result.value == null){
      return User.empty();
    }
    return result.value!;
  }

  Future<ResultOf<User>> getItemById(int id, int idApi) async {
    if (await _isConnectedToInternet()) {
      return _getItemById_Api(idApi);
    } else {
      //Se se tiene internet y cae aqui, el api no esta funcionando
      return await _getItemById_Cache(id);
    }
  }
  Future<ResultOf<User>> _getItemById_Cache(int id) async {
    try{
      User existe = _lItem.firstWhere(
            (c) => c.id == id,
        orElse: () => User.empty(),
      );
      return ResultOf<User>(
        success: true,
        message: '',
        errror: '',
        value: existe,
      );
    }catch(e){
      return ResultOf<User>(
        success: false,
        message: '',
        errror: '',
        e: e,
      );
    }
  }
  Future<ResultOf<User>> _getItemById_Api(int id) async {
    try{
      final url = Uri.parse('${Config.urlApi}/api/User/${id}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        User value = await User.fromMap(data, true);
        List<User> list = [value];
        _actualizarList(list, 0);
        return ResultOf<User>(
          success: true,
          value: list[0],
          message: 'User leido correctamente',
          errror: '',
        );
      } else {
        return ResultOf<User>(
          success: false,
          message: '',
          errror: 'Error al leer User',
        );
      }
    }catch(e){
      return ResultOf<User>(
        success: false,
        message: '',
        errror: 'Error al leer User',
        e: e,
      );
    }

  }


  Future<Result> createItem(User value) async {
    if (await _isConnectedToInternet()) {
      return _createItem_Api(value);
    } else {
      return await _createItem_Cache(value);
    }
  }
  Future<Result> _createItem_Cache(User value) async {
    value.local = 1;
    lItem.add(value);
    return Result(
      success: true,
      message: '',
      errror: '',
    );
  }
  Future<Result> _createItem_Api(User value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.post(
      Uri.parse('${Config.urlApi}/api/User'), // Cambia el endpoint según tu API
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      return Result(
        success: true,
        message: 'User agregado correctamente',
        errror: '',
      );
    } else {
      return Result(
        success: false,
        message: '',
        errror: 'Error al agregar User',
      );
    }
  }
  Future<Result> deleteItem(User value) async {
    value.estado = 0;
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }
  Future<Result> updateItem(User value) async {
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }
  Future<Result> _updateItem_Cache(User value) async {
    value.local = 2;
    return Result(
      success: true,
      message: 'User actualizado correctamente.',
      errror: '',
    );
  }
  Future<Result> _updateItem_Api(User value) async {
    value.local = 0;
    final response = await http.put(
      Uri.parse('${Config.urlApi}/api/User/${value.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(value.toMap()),
    );
    if (response.statusCode == 200) {
      return Result(
        success: true,
        message: 'User actualizado correctamente',
        errror: '',
      );
    } else {
      return Result(
        success: false,
        message: '',
        errror: 'Error al actualizar persona',
      );
    }
  }

  Future<ResultOf<List<User>>> fetchData(DateTime offset, int take, {bool forceRefresh = false}) async {
    if (await _isConnectedToInternet() || forceRefresh) {
      return _fetchData_Api(offset, take, null);
    } else {
      return await _fetchData_Cache(offset, take, null);
    }
  }

  Future<ResultOf<List<User>>> fetchDataFind(DateTime offset, int take, String? nombre, {bool forceRefresh = false}) async {
    if (await _isConnectedToInternet() || forceRefresh) {
      return _fetchData_Api(offset, take, nombre);
    } else {
      return await _fetchData_Cache(offset, take, nombre);
    }
  }

  Future<ResultOf<List<User>>> _fetchData_Api(DateTime offset, int take, String? nombre) async {
    String fecha = Parse.getDatetimeToStringFromQuery(offset);

    StringBuffer urlBuilder = StringBuffer('${Config.urlApi}/api/User?offsetDT=$fecha&take=$take');
    if (nombre != null && nombre.isNotEmpty) {
      urlBuilder.write('&nombre=$nombre');
    }
    String url = urlBuilder.toString();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<User> nuevosItem = await Future.wait(
            data.map((item) => User.fromMap(item, true))
        );
        bool seActualizaCache = false;
        for (int i = 0; i < nuevosItem.length; i++) {
          seActualizaCache = seActualizaCache || await _actualizarList(nuevosItem, i);
        }
        if (seActualizaCache){
          _sFromCache();
        }

        return ResultOf<List<User>>(
          success: true,
          message: '',
          errror: '',
          value: nuevosItem,
        );
      } else {
        return ResultOf<List<User>>(
          success: false,
          message: '',
          errror: 'Error al obtener datos del API',
          value: [],
          e: null,
        );
      }
    } catch (e) {
      return ResultOf<List<User>>(
        success: false,
        message: '',
        errror: 'Error al obtener datos del API',
        value: [],
        e: e,
      );
    }
  }

  Future<ResultOf<List<User>>> _fetchData_Cache(DateTime offset, int take, String? nombre) async {
    await _lFromCache();
    List<User> filteredItems = _lItem
        .where((value) {
      bool fechaValida = value.dtReg.isBefore(offset) && !value.dtReg.isAtSameMomentAs(offset);
      bool nombreValido = true;
      /*if(nombre != null){
        if (!nombre.isEmpty){
          nombreValido = value.nombre.contains(nombre);
        }
      }*/
      return fechaValida && nombreValido;
    }).toList();

    filteredItems.sort((a, b) => b.dtReg.compareTo(a.dtReg));
    List<User> items_ = filteredItems.take(take).toList();
    return ResultOf<List<User>>(
      success: true,
      message: '',
      errror: '',
      value: items_,
      e: null,
    );
  }


  Future<List<User>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> jsonData = json.decode(cachedData);
      List<User> nuevosItem = await Future.wait(
          jsonData.map((item) => User.fromMap(item, false))
      );
      return nuevosItem;
    } else {
      return [];
    }
  }
  bool _dataLoaded = false;
  Future<void> _lFromCache() async {
    if (_dataLoaded) {
      return;
    }
    _lItem = await _loadFromCache();
    _dataLoaded = true;
  }
  Future<void> _saveToCache(List<User> lVals) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(lVals.map((e) => e.toMap()).toList());
    await prefs.setString(_cacheKey, jsonData);
  }
  Future<void> _sFromCache() async {
    await _saveToCache(_lItem);
  }
  void updateLocalData(List<User> lVals) {
    _lItem = lVals;
  }
  Future<bool> _isConnectedToInternet() async {
    if (kIsWeb) {
      try {
        final response = await http.get(Uri.parse('${Config.urlApi}/api/Status'));
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    }
  }
  Future<bool> _actualizarList(List<User> nuevosItem, int i) async {//Map<String, dynamic>
    var nuevo = nuevosItem[i];
    int index = _lItem.indexWhere((value) => value.idApi == nuevo.idApi);
    if (index != -1) {
      late Map<String, dynamic> apiMap;
      late Map<String, dynamic> localMap;
      apiMap = nuevo.toMap();
      localMap = _lItem[index].toMap();
      if (apiMap == localMap){
        _lItem[index].setFromMap(apiMap, true);
        nuevosItem[i] = _lItem[index];
        return true;
      }
    } else {
      _lItem.add(nuevo);
      return true;
    }
    return false;
  }
}
