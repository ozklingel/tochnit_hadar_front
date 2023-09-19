import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@Riverpod(dependencies: [])
class UserService extends _$UserService {
  @override
  UserDto build() {
    return const UserDto(
      id: '1',
      firstName: 'אלכסוש',
      lastName: 'ינונוש',
      email: 'alexush@yanonush.com',
      apprentices: [
        ApprenticeDto(
          id: '1-11-21',
          avatar: 'https://i.pravatar.cc/75',
          firstName: 'יאיר',
          lastName: 'כהן',
        ),
        ApprenticeDto(
          id: '2-233-1431',
          avatar: 'https://i.pravatar.cc/75',
          firstName: 'נועם',
          lastName: 'שלמה',
        ),
        ApprenticeDto(
          id: '3-123-123',
          avatar: 'https://i.pravatar.cc/75',
          firstName: 'ארבל',
          lastName: 'בן נעים',
        ),
        ApprenticeDto(
          id: '4-123-123',
          avatar: 'https://i.pravatar.cc/75',
          firstName: 'יובל',
          lastName: 'אבידן',
        ),
      ],
    );
  }
}
