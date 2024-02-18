import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database_manager.dart';
import './note_model.dart'; // Sesuaikan dengan path yang benar

class NotesService extends GetxController {
  final RxList<Note> notes = <Note>[].obs; // Untuk menyimpan catatan

  int? _userId;

  NotesService() {
    _loadUserId();
  }

  // Memuat user_id dari SharedPreferences
  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
    getNotes(); // Memuat catatan setelah mendapatkan user_id
  }

  // Menambah catatan
  Future<void> addNote(Note note) async {
    final db = await DatabaseManager().database;
    note.userId = _userId; // Set user_id ke note
    await db.insert('notes', note.toMap());
    getNotes(); // Memperbarui daftar catatan setelah penambahan
  }

  // Mendapatkan semua catatan berdasarkan user_id
  Future<void> getNotes() async {
    final db = await DatabaseManager().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [_userId],
    );

    notes.value = List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Mendapatkan catatan berdasarkan ID dan user_id
  Future<Note?> getNoteById(int id) async {
    final db = await DatabaseManager().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, _userId],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // Memperbarui catatan
  Future<void> updateNote(Note note) async {
    final db = await DatabaseManager().database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [note.id, _userId],
    );
    getNotes();
  }

  // Menghapus catatan
  Future<void> deleteNote(int id) async {
    final db = await DatabaseManager().database;
    await db.delete(
      'notes',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, _userId],
    );
    getNotes();
  }

  // Memperbarui status catatan menjadi off
  Future<void> updateStatusToOff(int id) async {
    final db = await DatabaseManager().database;
    await db.update(
      'notes',
      {'status': Note.STATUS_OFF},
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, _userId],
    );
    getNotes();
  }
}
