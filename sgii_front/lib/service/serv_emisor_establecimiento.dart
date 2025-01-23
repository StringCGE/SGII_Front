import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sgii_front/util/common/parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/config.dart';

import 'package:sgii_front/model/cls_emisor_establecimiento.dart';

class EmisorEstablecimientoService {
  static final EmisorEstablecimientoService _singleton = EmisorEstablecimientoService._internal();
  static const String _cacheKey = 'value_cache_EmisorEstablecimiento';

  List<EmisorEstablecimiento> _lItem = [];

  EmisorEstablecimientoService._internal();

  factory EmisorEstablecimientoService() {
    return _singleton;
  }

  List<EmisorEstablecimiento> get lItem => _lItem;
  Future<EmisorEstablecimiento> directGetItemById(int id, int idApi) async {
    ResultOf<EmisorEstablecimiento> result = await getItemById(id, idApi);
    if (!result.success){
      return EmisorEstablecimiento.empty();
    }
    if (result.value == null){
      return EmisorEstablecimiento.empty();
    }
    return result.value!;
  }

  Future<ResultOf<EmisorEstablecimiento>> getItemById(int id, int idApi) async {
    if (await _isConnectedToInternet()) {
      return _getItemById_Api(idApi);
    } else {
      //Se se tiene internet y cae aqui, el api no esta funcionando
      return await _getItemById_Cache(id);
    }
  }
  Future<ResultOf<EmisorEstablecimiento>> _getItemById_Cache(int id) async {
    try{
      EmisorEstablecimiento existe = _lItem.firstWhere(
            (c) => c.id == id,
        orElse: () => EmisorEstablecimiento.empty(),
      );
      return ResultOf<EmisorEstablecimiento>(
        success: true,
        message: '',
        errror: '',
        value: existe,
      );
    }catch(e){
      return ResultOf<EmisorEstablecimiento>(
        success: false,
        message: '',
        errror: '',
        e: e,
      );
    }
  }
  Future<ResultOf<EmisorEstablecimiento>> _getItemById_Api(int id) async {
    try{
      final url = Uri.parse('${Config.urlApi}/api/EmisorEstablecimiento/${id}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        EmisorEstablecimiento value = await EmisorEstablecimiento.fromMap(data, true);
        List<EmisorEstablecimiento> list = [value];
        _actualizarList(list, 0);
        return ResultOf<EmisorEstablecimiento>(
          success: true,
          value: list[0],
          message: 'EmisorEstablecimiento leido correctamente',
          errror: '',
        );
      } else {
        return ResultOf<EmisorEstablecimiento>(
          success: false,
          message: '',
          errror: 'Error al leer EmisorEstablecimiento',
        );
      }
    }catch(e){
      return ResultOf<EmisorEstablecimiento>(
        success: false,
        message: '',
        errror: 'Error al leer EmisorEstablecimiento',
        e: e,
      );
    }

  }


  Future<Result> createItem(EmisorEstablecimiento value) async {
    if (await _isConnectedToInternet()) {
      return _createItem_Api(value);
    } else {
      return await _createItem_Cache(value);
    }
  }
  Future<Result> _createItem_Cache(EmisorEstablecimiento value) async {
    value.local = 1;
    lItem.add(value);
    return Result(
      success: true,
      message: '',
      errror: '',
    );
  }
  Future<Result> _createItem_Api(EmisorEstablecimiento value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.post(
      Uri.parse('${Config.urlApi}/api/EmisorEstablecimiento'), // Cambia el endpoint según tu API
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      return Result(
        success: true,
        message: 'EmisorEstablecimiento agregado correctamente',
        errror: '',
      );
    } else {
      return Result(
        success: false,
        message: '',
        errror: 'Error al agregar EmisorEstablecimiento',
      );
    }
  }
  Future<Result> deleteItem(EmisorEstablecimiento value) async {
    value.estado = 0;
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }
  Future<Result> updateItem(EmisorEstablecimiento value) async {
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }
  Future<Result> _updateItem_Cache(EmisorEstablecimiento value) async {
    value.local = 2;
    return Result(
      success: true,
      message: 'EmisorEstablecimiento actualizado correctamente.',
      errror: '',
    );
  }
  Future<Result> _updateItem_Api(EmisorEstablecimiento value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.put(
      Uri.parse('${Config.urlApi}/api/EmisorEstablecimiento/${value.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 200) {
      return Result(
        success: true,
        message: 'EmisorEstablecimiento actualizado correctamente',
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

  Future<ResultOf<List<EmisorEstablecimiento>>> fetchData(DateTime offset, int take, {bool forceRefresh = false}) async {
    if (await _isConnectedToInternet() || forceRefresh) {
      return _fetchData_Api(offset, take, null);
    } else {
      return await _fetchData_Cache(offset, take, null);
    }
  }

  Future<ResultOf<List<EmisorEstablecimiento>>> fetchDataFind(DateTime offset, int take, String? nombre, {bool forceRefresh = false}) async {
    if (await _isConnectedToInternet() || forceRefresh) {
      return _fetchData_Api(offset, take, nombre);
    } else {
      return await _fetchData_Cache(offset, take, nombre);
    }
  }

  Future<ResultOf<List<EmisorEstablecimiento>>> _fetchData_Api(DateTime offset, int take, String? nombre) async {
    String fecha = Parse.getDatetimeToStringFromQuery(offset);

    StringBuffer urlBuilder = StringBuffer('${Config.urlApi}/api/EmisorEstablecimiento?offsetDT=$fecha&take=$take');
    if (nombre != null && nombre.isNotEmpty) {
      urlBuilder.write('&nombre=$nombre');
    }
    String url = urlBuilder.toString();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<EmisorEstablecimiento> nuevosItem = await Future.wait(
            data.map((item) => EmisorEstablecimiento.fromMap(item, true))
        );
        bool seActualizaCache = false;
        for (int i = 0; i < nuevosItem.length; i++) {
          seActualizaCache = seActualizaCache || await _actualizarList(nuevosItem, i);
        }
        if (seActualizaCache){
          _sFromCache();
        }

        return ResultOf<List<EmisorEstablecimiento>>(
          success: true,
          message: '',
          errror: '',
          value: nuevosItem,
        );
      } else {
        return ResultOf<List<EmisorEstablecimiento>>(
          success: false,
          message: '',
          errror: 'Error al obtener datos del API',
          value: [],
          e: null,
        );
      }
    } catch (e) {
      return ResultOf<List<EmisorEstablecimiento>>(
        success: false,
        message: '',
        errror: 'Error al obtener datos del API',
        value: [],
        e: e,
      );
    }
  }

  Future<ResultOf<List<EmisorEstablecimiento>>> _fetchData_Cache(DateTime offset, int take, String? nombre) async {
    await _lFromCache();
    List<EmisorEstablecimiento> filteredItems = _lItem
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
    List<EmisorEstablecimiento> items_ = filteredItems.take(take).toList();
    return ResultOf<List<EmisorEstablecimiento>>(
      success: true,
      message: '',
      errror: '',
      value: items_,
      e: null,
    );
  }


  Future<List<EmisorEstablecimiento>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> jsonData = json.decode(cachedData);
      List<EmisorEstablecimiento> nuevosItem = await Future.wait(
          jsonData.map((item) => EmisorEstablecimiento.fromMap(item, false))
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
  Future<void> _saveToCache(List<EmisorEstablecimiento> lVals) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(lVals.map((e) => e.toMap()).toList());
    await prefs.setString(_cacheKey, jsonData);
  }
  Future<void> _sFromCache() async {
    await _saveToCache(_lItem);
  }
  void updateLocalData(List<EmisorEstablecimiento> lVals) {
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
  Future<bool> _actualizarList(List<EmisorEstablecimiento> nuevosItem, int i) async {//Map<String, dynamic>
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
