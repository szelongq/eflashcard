class Flashcard {
  final String en;
  final String hr;
  final String kj;

  const Flashcard({required this.en, required this.hr, required this.kj});

  // Adapted from https://stackoverflow.com/a/60862204
  Map<String, dynamic> _toMap() {
    return {
      'en': en,
      'hr': hr,
      'kj' : kj,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('Flashcard property not found');
  }

}
