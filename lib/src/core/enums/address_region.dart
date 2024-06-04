enum AddressRegion {
  none,
  center,
  jerusalem,
  north,
  south,
  yehuda;

  String get name {
    switch (this) {
      // TODO: OZ FIX FOR CORRECT VALUES OR ELSE RETURNS ERROR ON UPDATING
      case AddressRegion.center:
        return 'מחוז מרכז';
      case AddressRegion.jerusalem:
        return 'ירושלים והסביבה';
      case AddressRegion.north:
        return 'מחוז צפון';
      case AddressRegion.yehuda:
        return 'יהודה ושומרון';
      case AddressRegion.none:
      // return '';
      case AddressRegion.south:
        return 'מחוז דרום';
    }
  }
}
