import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/google_auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_signed_in_user.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'features/hotels/data/repositories/hotel_repository_impl.dart';
import 'features/hotels/domain/repositories/hotel_repository.dart';
import 'features/hotels/domain/usecases/get_popular_stays.dart';
import 'features/hotels/domain/usecases/get_search_results.dart';
import 'features/hotels/domain/usecases/register_device.dart';
import 'features/hotels/domain/usecases/search_autocomplete.dart';
import 'features/hotels/presentation/bloc/hotel_bloc.dart';
import 'features/hotels/presentation/bloc/search_bloc.dart';
import 'features/hotels/presentation/bloc/search_results_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(Connectivity.new);

  // Data sources
  sl.registerLazySingleton<GoogleAuthLocalDataSource>(
    () => GoogleAuthLocalDataSourceImpl(
      googleSignIn: sl(),
      firebaseAuth: sl(),
    ),
  );
  sl.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetSignedInUser(sl()));
  sl.registerLazySingleton(() => RegisterDevice(sl()));
  sl.registerLazySingleton(() => GetPopularStays(sl()));
  sl.registerLazySingleton(() => SearchAutocomplete(sl()));
  sl.registerLazySingleton(() => GetSearchResults(sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      signInWithGoogle: sl(),
      signOut: sl(),
      getSignedInUser: sl(),
    ),
  );
  sl.registerFactory(
    () => HotelBloc(
      registerDevice: sl(),
      getPopularStays: sl(),
    ),
  );
  sl.registerFactory(() => SearchBloc(searchAutocomplete: sl()));
  sl.registerFactory(() => SearchResultsBloc(getSearchResults: sl()));
}
