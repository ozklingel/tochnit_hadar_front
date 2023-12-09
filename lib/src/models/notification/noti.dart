class Noti {
  final String id;
  final String apprenticeId;
  final String event;
  final String date;
  final String timeFromNow;
  final String details;

  String allreadyread;
  final String numOfLinesDisplay;

  Noti(
    this.id,
    this.apprenticeId,
    this.event,
    this.date,
    this.timeFromNow,
    this.details,
    this.allreadyread,
    this.numOfLinesDisplay,
  );
  setAllreadyread(String wasRead) {
    allreadyread = wasRead;
  }
}
