enum MilitaryServiceType {
  commando,
  battalion,
  rear,
  unknown;

  static List<MilitaryServiceType> get services => values
      .where((element) => element != MilitaryServiceType.unknown)
      .toList();

  String get hebrewName => switch (this) {
        MilitaryServiceType.commando => 'סיירת',
        MilitaryServiceType.battalion => 'גדוד',
        MilitaryServiceType.rear => 'עורפי',
        _ => 'לא ידוע',
      };
}

extension MilitaryServiceTypeX on MilitaryServiceType {
  bool get isEmpty => this == MilitaryServiceType.unknown;
}
