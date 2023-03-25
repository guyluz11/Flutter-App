import 'package:cybear_jinni/domain/vendors/login_abstract/core_login_failures.dart';
import 'package:dartz/dartz.dart';

Either<CoreLoginFailure<String>, String>
    validateGenericXiaomiMiDeviceLoginPassiNotEmty(
  String input,
) {
  return right(input);
}
