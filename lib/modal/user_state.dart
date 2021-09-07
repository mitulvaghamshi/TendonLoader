/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:hive/hive.dart';

part 'user_state.g.dart';

@HiveType(typeId: 6)
class UserState extends HiveObject {
  UserState({
    this.keepSigned = true,
    this.userName = '',
    this.passWord = '',
  });

  @HiveField(0)
  bool? keepSigned;
  @HiveField(1)
  String? userName;
  @HiveField(2)
  String? passWord;
}
