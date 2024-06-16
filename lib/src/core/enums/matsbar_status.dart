enum MatsbarStatus {
  pious,
  connected,
  partial,
  leaving,
  disconnected,
  unknown;

  String get name {
    switch (this) {
      case pious:
        return 'אדוק';
      case connected:
        return 'מחובר';
      case partial:
        return 'מחובר חלקית';
      case leaving:
        return 'בשלבי ניתוק';
      case disconnected:
        return 'מנותק';
      case unknown:
      default:
        return 'לא ידוע';
    }
  }
}

extension MatsbarX on MatsbarStatus {
  bool get isEmpty => this == MatsbarStatus.unknown;
}
