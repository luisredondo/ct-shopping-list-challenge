import 'dart:ui';
import 'dart:math' as math;

Color generatePastelColor() {
  int random(int min, int max) {
    return min + math.Random().nextInt(max - min);
  }
  final r =  random(150, 256);
  final g =  random(150, 256);
  final b =  random(150, 256);

  return Color.fromRGBO(r, g, b, 1);
}
