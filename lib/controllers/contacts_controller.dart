import 'package:flutter/foundation.dart';

import '../models/contact.dart';

/// Holds the contacts list and the business rules:
///  - at most [maxContacts] contacts (the add button hides after that)
///  - the delete-last button only shows when the list is not empty
class ContactsController extends ChangeNotifier {
  static const int maxContacts = 6;

  final List<Contact> _contacts = [];

  List<Contact> get contacts => List.unmodifiable(_contacts);
  bool get isEmpty => _contacts.isEmpty;
  bool get canAdd => _contacts.length < maxContacts;

  void add(Contact contact) {
    if (!canAdd) return;
    _contacts.add(contact);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _contacts.length) return;
    _contacts.removeAt(index);
    notifyListeners();
  }

  void removeLast() {
    if (_contacts.isEmpty) return;
    _contacts.removeLast();
    notifyListeners();
  }
}
