import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcoin/services/auth.dart';

class CurrencyService {
  final User? user = Auth().currentUser;
  String? _userCurrency;

  final List<String> currencies = [
    'USD',
    'EUR',
    'JPY',
  ];

  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'JPY': 110.0,
    'CNY': 6.5,
  };

  List<String> getCurrencies() {
    return currencies;
  }

  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    await Future.delayed(Duration(seconds: 1)); // 模擬網絡延遲
    if (_rates.containsKey(fromCurrency) && _rates.containsKey(toCurrency)) {
      return _rates[toCurrency]! / _rates[fromCurrency]!;
    } else {
      throw Exception('Currency not found');
    }
  }

  Future<double> convert(
      double amount, String fromCurrency, String toCurrency) async {
    double rate = await getExchangeRate(fromCurrency, toCurrency);
    return amount * rate;
  }
}
