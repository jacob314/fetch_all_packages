bool validaCpf(String cpfNumber) {
  var numbers = cpfNumber.split('');
  int firstDigitMax = 10;
  int firstDigitSum = 0;
  for (var i = 0; i <= 8; i++) {
    firstDigitSum += (int.parse(numbers[i]) * firstDigitMax);
    firstDigitMax--;
  }

  int firstDigitVerification = ((firstDigitSum * 10) % 11);
  // print('First step verification');
  // print(firstDigitVerification);

  if (firstDigitVerification != int.parse(numbers[9])) {
    print('VALIDACPF: CPF INVÁLIDO');
    return false;
  }

  int secoundDigMax = 11;
  int soundDigSum = 0;
  for (var k = 0; k <= 9; k++) {
    soundDigSum += int.parse(numbers[k]) * secoundDigMax;
    secoundDigMax--;
  }
  int secoundDigitVerification = (((soundDigSum * 10) % 11));
  // print('Secound step verification');
  // print(secoundDigitVerification);
  if (secoundDigitVerification == int.parse(numbers[10])) {
    print('VALIDACPF: CPF VÁLIDO');
    return true;
  } else
    return false;
}
