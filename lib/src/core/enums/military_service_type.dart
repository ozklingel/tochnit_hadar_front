enum MilitaryServiceType {
  commando,
  battalion,
  rear,
  unknown;

  String get hebrewName => switch (this) {
        MilitaryServiceType.commando => 'סיירת',
        MilitaryServiceType.battalion => 'גדוד',
        MilitaryServiceType.rear => 'עורפי',
        _ => '?',
      };
}

extension MilitaryServiceTypeX on MilitaryServiceType {
  bool get isEmpty => this == MilitaryServiceType.unknown;
}
