import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/data/HomeState.dart';
import '../data/AddressSearchEvent.dart';
import '../data/AddressSearchState.dart';
import '../domain/AddressRepo.dart';
class AddressSearchBloc extends Bloc<AddressSearchEvent, AddressSearchState> {

  final AddressRepo repo;
  AddressSearchBloc( this.repo) : super(AddressInitial()) {
    on<FetchAddressSuggestions>((event, emit) async {
      if (event.query.isEmpty) return;
      emit(AddressLoading());
      try {
        final suggestions = await repo.fetchAddressSuggestions(event.query);
        emit(AddressLoaded(suggestions));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });
  }
}
