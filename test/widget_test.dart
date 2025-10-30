// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_travaly/core/error/failures.dart';
import 'package:my_travaly/features/auth/domain/entities/user.dart' as domain;
import 'package:my_travaly/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_travaly/features/auth/domain/usecases/get_signed_in_user.dart';
import 'package:my_travaly/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:my_travaly/features/auth/domain/usecases/sign_out.dart';
import 'package:my_travaly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_travaly/features/auth/presentation/pages/sign_in_page.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, domain.User>> signInWithGoogle() async {
    return const Right<Failure, domain.User>(
      domain.User(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
      ),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, domain.User?>> getSignedInUser() async {
    return const Right(null);
  }
}

void main() {
  testWidgets('Sign-in page renders welcome text', (tester) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          signInWithGoogle: SignInWithGoogle(repository),
          signOut: SignOut(repository),
          getSignedInUser: GetSignedInUser(repository),
        ),
        child: const MaterialApp(home: SignInPage()),
      ),
    );
    await tester.pump();
    expect(find.text('Welcome to MyTravaly'), findsOneWidget);
  });
}
