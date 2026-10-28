// Keeps the saved wizard draft in memory while the app is running.
// Leaving the wizard and coming back restores it.
// (Only Flutter and Dart are used, so the draft is cleared when the app closes.)
class DraftStorage {
  static Map<String, dynamic>? _draft;

  static bool get hasDraft => _draft != null;

  static void save(Map<String, dynamic> data) {
    _draft = Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic>? load() => _draft;

  static void clear() {
    _draft = null;
  }
}
