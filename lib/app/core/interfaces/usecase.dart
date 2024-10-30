import 'package:result_dart/result_dart.dart';

abstract interface class UseCase<SuccessType extends Object,
    FailureType extends Object, Params> {
  Future<Result<SuccessType, FailureType>> execute(Params params);
}

class NoParams {}
