// lib/bloc/address_search_bloc.dart
import 'package:chalosaath/features/home/domain/AddressRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/AddressSearchEvent.dart';
import '../data/AddressSearchState.dart';

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
