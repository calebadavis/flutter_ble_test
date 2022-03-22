import '../enums/kaatsu_exception_type.dart';

class KaatsuException implements Exception {

  KaatsuException({required this.type, this.cause = ''});

  String cause;
  KaatsuExceptionType type;
}