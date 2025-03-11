import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'ecommerce.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER,
            title TEXT,
            price REAL,
            quantity INTEGER,
            image TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            products TEXT,
            totalPrice REAL,
            orderDate TEXT,
            status TEXT DEFAULT 'Pending'
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS orders (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              email TEXT,
              products TEXT,
              totalPrice REAL,
              orderDate TEXT,
              status TEXT DEFAULT 'Pending'
            )
          ''');
        }
      },
    );
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'orderDate DESC');
  }

  Future<void> deleteOrder(int orderId) async {
    final db = await database;
    await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}