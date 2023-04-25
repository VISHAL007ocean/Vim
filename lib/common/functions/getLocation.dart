import 'package:geolocator/geolocator.dart';

Future<Position> getLocation() async {
  Position pos;
  try {
    Position newPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .timeout(new Duration(seconds: 5));

    pos = newPosition;
  } catch (e) {
    print('Error: ${e.toString()}');
    throw e;
  }
  return pos;
}
