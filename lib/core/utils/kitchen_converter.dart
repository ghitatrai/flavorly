class KitchenConverter {
  // Temperature conversion
  static double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;
  static double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;

  // Cup to Gram approximations (density dependent)
  static double cupsToGrams(String ingredient, double cups) {
    switch (ingredient.toLowerCase()) {
      case 'flour':
        return cups * 125;
      case 'sugar (granulated)':
        return cups * 200;
      case 'butter':
        return cups * 225;
      case 'brown sugar':
        return cups * 220;
      case 'cocoa powder':
        return cups * 100;
      default:
        return cups * 150; // General average default
    }
  }
}