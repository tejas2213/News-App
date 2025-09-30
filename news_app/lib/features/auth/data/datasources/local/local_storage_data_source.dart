import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/entities/user_entity.dart';

abstract class LocalStorageDataSource {
  Future<Either<String, void>> saveUserSession(UserEntity user);
  Future<Either<String, UserEntity?>> getUserSession();
  Future<Either<String, void>> clearUserSession();
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final SharedPreferences _preferences;

  LocalStorageDataSourceImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  @override
  Future<Either<String, void>> saveUserSession(UserEntity user) async {
    try {
      final userJson = user.toJson();
      final success = await _preferences.setString(
        'user_session',
        jsonEncode(userJson),
      );
      return success ? const Right(null) : const Left('Failed to save user session');
    } catch (e) {
      return Left('Error saving user session: $e');
    }
  }

  @override
  Future<Either<String, UserEntity?>> getUserSession() async {
    try {
      final userJsonString = _preferences.getString('user_session');
      if (userJsonString != null) {
        final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
        return Right(UserEntity.fromJson(userJson));
      }
      return const Right(null);
    } catch (e) {
      return Left('Error getting user session: $e');
    }
  }

  @override
  Future<Either<String, void>> clearUserSession() async {
    try {
      final success = await _preferences.remove('user_session');
      return success ? const Right(null) : const Left('Failed to clear user session');
    } catch (e) {
      return Left('Error clearing user session: $e');
    }
  }
}