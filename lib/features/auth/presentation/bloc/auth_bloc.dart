import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_signed_in_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required GetSignedInUser getSignedInUser,
  })  : _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _getSignedInUser = getSignedInUser,
        super(const AuthInitial()) {
    on<AuthStatusRequested>(_onAuthStatusRequested);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
  }

  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final GetSignedInUser _getSignedInUser;

  Future<void> _onAuthStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getSignedInUser(NoParams());
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signInWithGoogle(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message ?? 'Unable to sign in')),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final Either<Failure, void> result = await _signOut(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message ?? 'Unable to sign out')),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
