class Result{
  final String errror;
  final String message;
  final String statusCode;
  final dynamic value;
  final bool success;
  final dynamic e;
  final int intentos;
  final bool usuarioBloqueado;
  Result({
    required this.success,
    this.errror = '',
    this.message = '',
    this.statusCode = '',
    this.value = null,
    this.e = null,
    this.intentos = -1,
    this.usuarioBloqueado = false,
  });
}

class ResultOf<t>{
  final bool success;
  final String errror;
  final String message;
  final String statusCode;
  final t? value;
  final dynamic e;

  ResultOf({
    required this.success,
    this.errror = '',
    this.message = '',
    this.statusCode = '',
    this.value = null,
    this.e = null,
  });
}