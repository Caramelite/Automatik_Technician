import 'package:form_field_validator/form_field_validator.dart';

class UnifiedValidators {
  static MultiValidator emailValidator = MultiValidator([
    RequiredValidator(errorText: "Please enter an email address"),
    EmailValidator(errorText: "Please enter a valid email"),
  ]);

  static MultiValidator passwordRegisterValidator = MultiValidator([
    RequiredValidator(errorText: 'A password is required'),
    MinLengthValidator(8,
        errorText: 'The password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character')
  ]);
  static MultiValidator passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'A password is required'),
    MinLengthValidator(6,
        errorText: 'The password must be at least 6 digits long'),
  ]);
  static MultiValidator emptyValidator = MultiValidator([
    RequiredValidator(errorText: 'Cannot be Empty'),
  ]);
}
