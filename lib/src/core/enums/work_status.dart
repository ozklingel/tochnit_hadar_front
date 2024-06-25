enum WorkStatus {
  preService,
  mandatoryService,
  extendedService,
  released,
  trip,
  yeshiva,
  studies,
  unknown;

  static List<WorkStatus> get statuses =>
      values.where((e) => e != unknown).toList();

  String get name => switch (this) {
        preService => 'טרום גיוס',
        mandatoryService => 'בשירות סדיר',
        extendedService => 'בקבע',
        released => 'משוחרר',
        trip => 'טיול אחרי צבא',
        yeshiva => 'ישיבה אחרי צבא',
        studies => 'לימודים',
        _ => 'לא ידוע',
      };
}
