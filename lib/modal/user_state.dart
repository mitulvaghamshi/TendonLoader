import 'package:hive/hive.dart';

part 'user_state.g.dart';

@HiveType(typeId: 6)
class UserState extends HiveObject {
  UserState({
    this.firstRun = true,
    this.keepSigned = true,
    this.userName = '',
    this.passWord = '',
  });

  @HiveField(1)
  bool? firstRun;
  @HiveField(2)
  bool? keepSigned;
  @HiveField(3)
  String? userName;
  @HiveField(4)
  String? passWord;
}
