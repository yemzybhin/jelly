class Formatter{
  static String shortenText( {required String text , required int length }){

    if(text.length < length ){
      return '${text.substring(0 , 1).toUpperCase()}${text.substring(1 , text.length)}';
    }
    return "${text.substring(0 , 1).toUpperCase()}${text.substring(1 , length)}...";
  }

  static String shortenTextCharacter({required String text, required int length}) {
    if (text.isEmpty) return "";
    if (text.length <= length) {
      return text[0].toUpperCase() + text.substring(1);
    }
    return text[0].toUpperCase() + text.substring(1, length) + "...";
  }


  static String formatToCurrency(num number, String currency) {
    if (number >= 0 && number < 1000) {
      return "$currency$number";
    } else if (number >= 1000 && number < 1000000) {
      double result = number / 1000;
      return '$currency${_formatNumber(result)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      double result = number / 1000000;
      return '$currency${_formatNumber(result, decimals: 2)}M';
    } else if (number >= 1000000000) {
      double result = number / 1000000000;
      return '$currency${_formatNumber(result, decimals: 2)}B';
    } else {
      return 'Invalid Input';
    }
  }

  static String _formatNumber(double number, {int decimals = 1}) {
    if (number - number.toInt() == 0) {
      return number.toInt().toString(); // Returns the number without decimals if the decimal is zero
    } else {
      return number.toStringAsFixed(decimals); // Returns the number with specified decimals otherwise
    }
  }

  static String formatK(num number) {
    if (number >= 0 && number < 1000) {
      return number.toString();
    } else if (number >= 1000 && number < 1000000) {
      double result = number / 1000;
      return '${result.toStringAsFixed(2)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      double result = number / 1000000;
      return '${result.toStringAsFixed(2)}M';
    } else if (number >= 1000000000) {
      double result = number / 1000000000;
      return '${result.toStringAsFixed(2)}B';
    } else {
      return 'Invalid Input';
    }
  }


  static String to11DigitNum (String value){
    if(value.length == 14){
      return '0' + value.substring(4, 14);
    }
    return value;
  }

  static String toPascalCase(String input) =>
      input.split(RegExp(r'[_\s]+')).map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '').join('');
}