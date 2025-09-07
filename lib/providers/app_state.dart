import 'package:flutter/material.dart';
import '../models/leave.dart';
import '../models/staff.dart';
import '../models/surgery.dart';
import '../services/database_service.dart';
import '../models/surgeon.dart';

class AppState with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = true;

  AppState() {
    initialize();
  }

  Future<void> initialize() async {
    await _dbService.init();
    await _loadData();
  }

  bool get isLoading => _isLoading;

  // Master Data
  List<Staff> _staff = [];
  List<Surgeon> _surgeons = [];

  List<Staff> get staff => _staff;
  List<Surgeon> get surgeons => _surgeons;

  Future<void> _loadData() async {
    _staff = await _dbService.getStaff();
    _surgeons = await _dbService.getSurgeons();
    _leave = await _dbService.getLeave();
    _surgeries = await _dbService.getSurgeries();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addStaff(Staff newStaff) async {
    _staff.add(newStaff);
    await _dbService.saveStaff(_staff);
    notifyListeners();
  }

  Future<void> removeStaff(String staffId) async {
    _staff.removeWhere((s) => s.id == staffId);
    await _dbService.saveStaff(_staff);
    notifyListeners();
  }

  Future<void> addSurgeon(Surgeon newSurgeon) async {
    _surgeons.add(newSurgeon);
    await _dbService.saveSurgeons(_surgeons);
    notifyListeners();
  }

  Future<void> removeSurgeon(String surgeonId) async {
    _surgeons.removeWhere((s) => s.id == surgeonId);
    await _dbService.saveSurgeons(_surgeons);
    notifyListeners();
  }

  // Sunday & Leave Management
  List<Leave> _leave = [];
  List<Staff> _sundayRoster = [];

  List<Leave> get leave => _leave;
  List<Staff> get sundayRoster => _sundayRoster;

  Future<void> addLeave(Leave newLeave) async {
    _leave.add(newLeave);
    await _dbService.saveLeave(_leave);
    notifyListeners();
  }

  Future<void> removeLeave(String leaveId) async {
    _leave.removeWhere((l) => l.id == leaveId);
    await _dbService.saveLeave(_leave);
    notifyListeners();
  }

  void generateSundayRoster() {
    final today = DateTime.now();
    final nextSunday = today.add(Duration(days: 7 - today.weekday));
    final leaveOnSunday = _leave
        .where(
          (l) =>
              l.date.year == nextSunday.year &&
              l.date.month == nextSunday.month &&
              l.date.day == nextSunday.day,
        )
        .map((l) => l.staffId)
        .toList();
    _sundayRoster = _staff.where((s) => !leaveOnSunday.contains(s.id)).toList();
    notifyListeners();
  }

  // Daily OT Scheduling
  final List<String> _selectedOts = [];
  List<Surgery> _surgeries = [];
  final Map<String, List<Staff>> _allocatedStaff = {};

  List<String> get selectedOts => _selectedOts;
  List<Surgery> get surgeries => _surgeries;
  Map<String, List<Staff>> get allocatedStaff => _allocatedStaff;

  void toggleOtSelection(String ot) {
    if (_selectedOts.contains(ot)) {
      _selectedOts.remove(ot);
      _surgeries.removeWhere((s) => s.otId == ot);
    } else {
      _selectedOts.add(ot);
      _surgeries.add(Surgery(id: DateTime.now().toString(), otId: ot));
    }
    notifyListeners();
  }

  Future<void> updateSurgery(Surgery surgery) async {
    final index = _surgeries.indexWhere((s) => s.id == surgery.id);
    if (index != -1) {
      _surgeries[index] = surgery;
    } else {
      _surgeries.add(surgery);
    }
    await _dbService.saveSurgeries(_surgeries);
    notifyListeners();
  }

  void toggleStaffAllocation(String otId, Staff staff) {
    if (_allocatedStaff[otId] == null) {
      _allocatedStaff[otId] = [];
    }
    if (_allocatedStaff[otId]!.any((s) => s.id == staff.id)) {
      _allocatedStaff[otId]!.removeWhere((s) => s.id == staff.id);
    } else {
      _allocatedStaff[otId]!.add(staff);
    }
    notifyListeners();
  }
}
