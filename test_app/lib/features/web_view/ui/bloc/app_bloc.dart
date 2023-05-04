import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_app/features/web_view/domain/app_usecase.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required this.usecase}) : super(InitState()) {
    on<GetConfigEvent>((event, emit) async {
      emit(LoadingState());
      final String response = await usecase.getConfig();
      if (response == '') {
        emit(MockState());
      } else if (response == 'error') {
        emit(ErrorState());
      } else {
        emit(SuccessState(response: response));
      }
    });
    on<GetSavedConfigEvent>((event, emit) async {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        emit(SuccessState(response: event.localData));
      } else {
        emit(ErrorState());
      }
    });
  }
  final AppUsecase usecase;
}

//events
class AppEvent {}

class GetConfigEvent extends AppEvent {}

class GetSavedConfigEvent extends AppEvent {
  GetSavedConfigEvent({required this.localData});
  final String localData;
}

//state
class AppState {}

class InitState extends AppState {}

class LoadingState extends AppState {}

class SuccessState extends AppState {
  SuccessState({required this.response});
  final String response;
}

class MockState extends AppState {}

class ErrorState extends AppState {}
