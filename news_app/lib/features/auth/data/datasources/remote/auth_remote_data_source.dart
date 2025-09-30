import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<Either<String, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await userCredential.user?.updateDisplayName(displayName);
      
      final user = userCredential.user;
      if (user != null) {
        return Right(UserEntity(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName ?? displayName,
        ));
      } else {
        return const Left('User creation failed');
      }
    } on FirebaseAuthException catch (e) {
      return Left(_getErrorMessage(e));
    } catch (e) {
      return Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        return Right(UserEntity(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName,
        ));
      } else {
        return const Left('Sign in failed');
      }
    } on FirebaseAuthException catch (e) {
      return Left(_getErrorMessage(e));
    } catch (e) {
      return Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left('Sign out failed: $e');
    }
  }

  @override
  Future<Either<String, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return Right(UserEntity(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName,
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left('Failed to get current user: $e');
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return e.message ?? 'An unexpected error occurred';
    }
  }
}