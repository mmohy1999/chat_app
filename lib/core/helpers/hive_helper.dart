import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper<T> {
   final String  _boxName ;

   HiveHelper(this._boxName);

  Future<Box<T>> get _box async =>
      await Hive.openBox<T>(_boxName);

//create
  Future<void> add(T model) async {
    var box = await _box;
    await box.add(model);
  }
  Future<void> addAll(List<T> list) async {
    var box = await _box;
    for (var model in list) {
      await box.add(model);
    }
  }

//read
  Future<T> get(int index) async {
    var box = await _box;
    return box.values.toList()[index];
  }
  Future<List<T>> getAll() async {
    var box = await _box;
    return box.values.toList();
  }

//update
  Future<void> update(int index, T model) async {
    var box = await _box;
    await box.putAt(index, model);
  }

//delete
//   Future<void> deleteAll() async {
//     var box = await _box;
//     await box.deleteAll(keys);
//   }
  Future<void> delete(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }
}