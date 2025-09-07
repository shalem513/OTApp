import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import 'package:ot_roster/models/leave.dart';
import 'package:ot_roster/models/staff.dart';
import 'package:ot_roster/models/surgery.dart';
import 'package:ot_roster/models/surgeon.dart';

class DatabaseService {
  static const String dbName = 'ot_scheduler.db';
  Database? _db;

  Future<void> init() async {
    if (_db == null) {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, dbName);
      _db = await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  Future<Database> get db async {
    if (_db == null) {
      await init();
    }
    return _db!;
  }

  Future<void> saveStaff(List<Staff> staff) async {
    final store = stringMapStoreFactory.store('staff');
    await store.delete(await db);
    await store.addAll(await db, staff.map((s) => s.toJson()).toList());
  }

  Future<List<Staff>> getStaff() async {
    final store = stringMapStoreFactory.store('staff');
    final snapshots = await store.find(await db);
    return snapshots.map((s) => Staff.fromJson(s.value)).toList();
  }

  Future<void> saveSurgeons(List<Surgeon> surgeons) async {
    final store = stringMapStoreFactory.store('surgeons');
    await store.delete(await db);
    await store.addAll(await db, surgeons.map((s) => s.toJson()).toList());
  }

  Future<List<Surgeon>> getSurgeons() async {
    final store = stringMapStoreFactory.store('surgeons');
    final snapshots = await store.find(await db);
    return snapshots.map((s) => Surgeon.fromJson(s.value)).toList();
  }

  Future<void> saveLeave(List<Leave> leave) async {
    final store = stringMapStoreFactory.store('leave');
    await store.delete(await db);
    await store.addAll(await db, leave.map((l) => l.toJson()).toList());
  }

  Future<List<Leave>> getLeave() async {
    final store = stringMapStoreFactory.store('leave');
    final snapshots = await store.find(await db);
    return snapshots.map((s) => Leave.fromJson(s.value)).toList();
  }

  Future<void> saveSurgeries(List<Surgery> surgeries) async {
    final store = stringMapStoreFactory.store('surgeries');
    await store.delete(await db);
    await store.addAll(await db, surgeries.map((s) => s.toJson()).toList());
  }

  Future<List<Surgery>> getSurgeries() async {
    final store = stringMapStoreFactory.store('surgeries');
    final snapshots = await store.find(await db);
    return snapshots.map((s) => Surgery.fromJson(s.value)).toList();
  }
}
