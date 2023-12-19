import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_service.g.dart';

@Riverpod(
  dependencies: [
    dio,
  ],
)
class UserService extends _$UserService {
  @override
  Future<UserDto> build() async {
    final request = await ref
        .watch(dioProvider)
        .get('userProfile_form/getProfileAtributes');

    final user = UserDto.fromJson(request.data);

    ref.keepAlive();

    return user;

    // return const UserDto(
    //   id: '1',
    //   firstName: 'אלכסוש',
    //   lastName: 'ינונוש',
    //   email: 'alexush@yanonush.com',
    //   role: UserRole.ahraiTohnit,
    //   apprentices: [
    //     ApprenticeDto(
    //       id: '1-11-21',
    //       avatar: 'https://i.pravatar.cc/75',
    //       firstName: 'יאיר',
    //       lastName: 'כהן',
    //     ),
    //     ApprenticeDto(
    //       id: '2-233-1431',
    //       avatar: 'https://i.pravatar.cc/75',
    //       firstName: 'נועם',
    //       lastName: 'שלמה',
    //     ),
    //     ApprenticeDto(
    //       id: '3-123-123',
    //       avatar: 'https://i.pravatar.cc/75',
    //       firstName: 'ארבל',
    //       lastName: 'בן נעים',
    //     ),
    //     ApprenticeDto(
    //       id: '4-123-123',
    //       avatar: 'https://i.pravatar.cc/75',
    //       firstName: 'יובל',
    //       lastName: 'אבידן',
    //     ),
    //   ],
    // );
  }
}
