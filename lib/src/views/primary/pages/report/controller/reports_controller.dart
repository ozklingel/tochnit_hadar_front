import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/report/report.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports_controller.g.dart';

@Riverpod(dependencies: [])
class ReportsController extends _$ReportsController {
  @override
  FutureOr<List<ReportDto>> build() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final reports = [
      ReportDto(
        id: '1-1',
        description: 'תיאור הדיווח',
        dateTimeInMsSinceEpoch: DateTime.now()
            .subtract(const Duration(minutes: 55))
            .millisecondsSinceEpoch,
        reportEventType: ReportEventType.phoneCall,
        apprentices: [
          const ApprenticeDto(
            firstName: 'יאיר',
            lastName: 'כהן',
          ),
        ],
      ),
      ReportDto(
        id: '232-67-112',
        description: 'תיאור הדיווח',
        dateTimeInMsSinceEpoch: DateTime.now()
            .subtract(const Duration(days: 77))
            .millisecondsSinceEpoch,
        reportEventType: ReportEventType.phoneCall,
        apprentices: [
          const ApprenticeDto(
            firstName: 'יאיר',
            lastName: 'כהן',
          ),
        ],
      ),
      ReportDto(
        id: '3-2',
        description: '2תיאור הדיווח',
        dateTimeInMsSinceEpoch: DateTime.now()
            .subtract(const Duration(hours: 55))
            .millisecondsSinceEpoch,
        reportEventType: ReportEventType.offlineMeeting,
        apprentices: [
          const ApprenticeDto(
            avatar: 'https://i.pravatar.cc/75',
            firstName: 'יאיר',
            lastName: 'כהן',
          ),
          const ApprenticeDto(
            avatar: 'https://i.pravatar.cc/75',
            firstName: 'נועם',
            lastName: 'שלמה',
          ),
          const ApprenticeDto(
            avatar: 'https://i.pravatar.cc/75',
            firstName: 'ארבל',
            lastName: 'בן נעים',
          ),
          const ApprenticeDto(
            avatar: 'https://i.pravatar.cc/75',
            firstName: 'יובל',
            lastName: 'אבידן',
          ),
        ],
      ),
      ReportDto(
        id: '67-112',
        description: 'תיאור הדיווח',
        dateTimeInMsSinceEpoch: DateTime.now()
            .subtract(const Duration(days: 364))
            .millisecondsSinceEpoch,
        reportEventType: ReportEventType.phoneCall,
        apprentices: [
          const ApprenticeDto(
            firstName: 'יאיר',
            lastName: 'כהן',
          ),
        ],
      ),
      ReportDto(
        id: '232-67-112-23123',
        description: 'תיאור הדיווח',
        dateTimeInMsSinceEpoch: DateTime.now()
            .subtract(const Duration(days: 800))
            .millisecondsSinceEpoch,
        reportEventType: ReportEventType.phoneCall,
        apprentices: [
          const ApprenticeDto(
            firstName: 'יאיר',
            lastName: 'כהן',
          ),
        ],
      ),
    ];

    reports.sort(
      (a, b) => b.dateTimeInMsSinceEpoch.compareTo(a.dateTimeInMsSinceEpoch),
    );

    return reports;
  }
}
