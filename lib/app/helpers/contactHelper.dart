import 'package:agendadecontatos/app/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final table = "contactTable";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  ContactHelper.internal();
  factory ContactHelper() => _instance;

  Database _db;

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    } else {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, "contacts.db");
    
    return await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async {
      await db.execute(
        "CREATE TABLE $table("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "email TEXT,"
            "phone TEXT,"
            "img TEXT);"
      );
    });
  }

  Future<Contact> save(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(table, contact.toMap());
    return contact;
  }

  Future<Contact> findById(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(table,
      where: "id = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(table, contact.toMap(),
        where: "id = ?", whereArgs: [contact.id]);
  }

  Future<List> getAll() async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.rawQuery("SELECT * FROM $table");
    List<Contact> contacts = List();
    for(Map m in maps) {
      contacts.add(Contact.fromMap(m));
    }
    return contacts;
  }

  Future<int> countContacts() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  Future closeDb() async {
    Database dbContact = await db;
    await dbContact.close();
  }


}