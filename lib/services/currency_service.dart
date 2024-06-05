class CurrencyService {
  final List<String> currencies = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
  ];

  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.97,
    'JPY': 114.07,
    'GBP': 0.82,
    'AUD': 1.43,
    'CHF': 0.94,
    'CNY': 6.71,
    'INR': 78.00,
    'BRL': 5.43
  };

  List<String> get getAvailableCurrencies => currencies;

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
