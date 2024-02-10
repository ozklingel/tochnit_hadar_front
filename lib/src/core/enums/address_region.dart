enum AddressRegion {
  none,
  center,
  jerusalem,
  north,
  south,
  yehuda;

  String get name {
    switch (this) {
      case AddressRegion.none:
        return '';
      case AddressRegion.center:
        return 'אזור המרכז';
      case AddressRegion.jerusalem:
        return 'ירושלים והסביבה';
      case AddressRegion.north:
        return 'אזור הצפון';
      case AddressRegion.south:
        return 'אזור הדרום';
      case AddressRegion.yehuda:
        return 'יהודה ושומרון';
    }
  }
}
