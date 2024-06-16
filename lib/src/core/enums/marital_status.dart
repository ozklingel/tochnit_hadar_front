enum MaritalStatus {
  married,
  single,
  widow,
  divorced,
  unknown;

  String get name {
    switch (this) {
      case married:
        return 'נשוי';
      case single:
        return 'רווק';
      case widow:
        return 'אלמן';
      case divorced:
        return 'גרוש';
      case unknown:
      default:
        return 'לא ידוע';
    }
  }
}
