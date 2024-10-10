import 'package:flutter_bloc/flutter_bloc.dart';
import 'calls_state.dart';

class CallCubit extends Cubit<CallsState> {
  CallCubit() : super(const CallsState.initial());
}
