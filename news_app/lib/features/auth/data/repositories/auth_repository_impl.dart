import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../datasources/local/local_storage_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorageDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required LocalStorageDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<String, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final result = await _remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    return result;
  }

  @override
  Future<Either<String, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.fold((error) => Left(error), (user) async {
      final saveResult = await _localDataSource.saveUserSession(user);
      return saveResult.fold((error) => Left(error), (_) => Right(user));
    });
  }

  @override
  Future<Either<String, void>> signOut() async {
    final remoteResult = await _remoteDataSource.signOut();
    return remoteResult.fold((error) => Left(error), (_) async {
      final localResult = await _localDataSource.clearUserSession();
      return localResult.fold((error) => Left(error), (_) => const Right(null));
    });
  }

  @override
  Future<Either<String, UserEntity?>> getCurrentUser() async {
    try {
      final remoteResult = await _remoteDataSource.getCurrentUser();

      return remoteResult.fold((error) => Left(error), (remoteUser) async {
        if (remoteUser != null) {
          final saveResult = await _localDataSource.saveUserSession(remoteUser);
          return saveResult.fold(
            (error) => Left(error),
            (_) => Right(remoteUser),
          );
        } else {
          final localResult = await _localDataSource.getUserSession();
          return localResult.fold((error) => Left(error), (localUser) {
            if (localUser != null) {
              _localDataSource.clearUserSession();
              return const Right(null);
            }
            return const Right(null);
          });
        }
      });
    } catch (e) {
      return Left('Error checking authentication status: $e');
    }
  }

  @override
  Future<Either<String, void>> saveUserSession(UserEntity user) {
    return _localDataSource.saveUserSession(user);
  }

  @override
  Future<Either<String, UserEntity?>> getUserSession() {
    return _localDataSource.getUserSession();
  }

  @override
  Future<Either<String, void>> clearUserSession() {
    return _localDataSource.clearUserSession();
  }
}
