import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ledge/misc/utils.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/model/userModel.dart';
import 'package:ledge/services/coins_api.dart';

final authUser = FirebaseAuth.instance.currentUser!;

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Signout
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Create user
  Future createUser(String uid, String name, String email) async {
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    final json = {
      'uid': uid,
      'name': name,
      'email': email,
      'ledger': {},
    };

    /// Create document and write data to Firebase
    return await docUser.set(json);
  }

  static Stream<Future<AppUser?>> getUserStream() =>
      Stream.periodic(Duration(seconds: 5)).asyncMap((_) => userStream());

  // Get user
  static Future<AppUser?> userStream() async {
    /// Get single document by ID
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(authUser.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.data()!);
    }
  }

  Future<AppUser?> getUser() async {
    /// Get single document by ID
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(authUser.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.data()!);
    }
  }

  Future<List<Coin>> getLedger() async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await doc.get();
    final ledger = snapshot['ledger'];

    List<Coin> coins = [];

    for (var item in ledger.entries) {
      final coin = await CoinsApi.getCoin(item.key);
      coins.add(coin);
    }

    return coins;
  }

  // Add coin
  Future<bool> addCoin(coinId) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await doc.get();
    final ledger = snapshot['ledger'];

    if (ledger.containsKey(coinId)) {
      Utils.showSnackBar('You already have this coin');
      return false;
    }

    ledger[coinId] = '0.00';
    doc.update({'ledger': ledger});

    return true;
  }

  // Delete coin
  Future<void> deleteCoin(coinId) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await doc.get();
    final ledger = snapshot['ledger'];

    ledger.removeWhere((key, value) => key == coinId);

    doc.update({'ledger': ledger});
  }

  // Buy coin
  Future<void> buyCoin(coinId, payload) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await doc.get();
    final ledger = snapshot['ledger'];

    if (payload > 0) {
      ledger.update(
          coinId, (value) => (double.parse(value) + payload).toString());

      doc.update({'ledger': ledger});
    } else {
      Utils.showSnackBar('Buy amount must be greater than zero');
    }
  }

  // Sell coin
  Future<void> sellCoin(coinId, payload) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await doc.get();
    final ledger = snapshot['ledger'];

    if (payload <= double.parse(ledger[coinId])) {
      ledger.update(
          coinId, (value) => (double.parse(value) - payload).toString());

      doc.update({'ledger': ledger});
    } else {
      Utils.showSnackBar('Sell amount greater than wallet balance');
    }
  }
}
