import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });
  
  Future<Either<String, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  Future<Either<String, void>> signOut();
  Future<Either<String, UserEntity?>> getCurrentUser();
  Future<Either<String, void>> saveUserSession(UserEntity user);
  Future<Either<String, UserEntity?>> getUserSession();
  Future<Either<String, void>> clearUserSession();
}