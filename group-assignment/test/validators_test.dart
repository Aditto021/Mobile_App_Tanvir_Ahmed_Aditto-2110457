import 'package:flutter_test/flutter_test.dart';
import 'package:form_app/utils/validators.dart';

void main() {
  test('name', () {
    expect(Validators.nameValidator(''), isNotNull);
    expect(Validators.nameValidator('A'), isNotNull);
    expect(Validators.nameValidator('Tanvir123'), isNotNull);
    expect(Validators.nameValidator('Tanvir Ahmed'), isNull);
  });

  test('email', () {
    expect(Validators.emailValidation('abc'), isNotNull);
    expect(Validators.emailValidation('abc@gmail'), isNotNull);
    expect(Validators.emailValidation('tanvir.ahmed@gmail.com'), isNull);
  });

  test('Bangladesh phone', () {
    expect(Validators.bangladeshNumberValidator('01712345678'), isNull);
    expect(Validators.bangladeshNumberValidator('+8801712345678'), isNull);
    expect(Validators.bangladeshNumberValidator('017 1234 5678'), isNull);
    expect(Validators.bangladeshNumberValidator('0171234567'), isNotNull);
    expect(Validators.bangladeshNumberValidator('01212345678'), isNotNull);
  });

  test('age', () {
    expect(Validators.ageValidator('abc'), isNotNull);
    expect(Validators.ageValidator('12'), isNotNull);
    expect(Validators.ageValidator('121'), isNotNull);
    expect(Validators.ageValidator('25'), isNull);
  });

  test('NID', () {
    expect(Validators.nidValidator('12345'), isNotNull);
    expect(Validators.nidValidator('1234567890'), isNull);
    expect(Validators.nidValidator('1234567890123'), isNull);
    expect(Validators.nidValidator('12345678901234567'), isNull);
  });

  test('password and strength', () {
    expect(Validators.passwordValidator('short'), isNotNull);
    expect(Validators.passwordValidator('alllowercase1!'), isNotNull);
    expect(Validators.passwordValidator('Strong@123'), isNull);
    expect(Validators.passwordStrength(''), 0);
    expect(Validators.passwordStrength('Strong@123'), 5);
  });

  test('confirm password', () {
    expect(
      Validators.confirmPasswordValidator('Abc@1234', 'Abc@123'),
      isNotNull,
    );
    expect(Validators.confirmPasswordValidator('Abc@1234', 'Abc@1234'), isNull);
  });
}
