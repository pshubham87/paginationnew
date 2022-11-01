import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel extends HiveObject {
  @HiveField(0)
  late int userId;

  @HiveField(1)
  late int id;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String body;

}
