part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.contacts = const [],
  });

  final HomeStatus status;
  final List<Contact> contacts;

  @override
  List<Object> get props => [status, contacts];
}
