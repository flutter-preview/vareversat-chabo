import 'package:chabo/app_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: AppThemes.brightTheme)) {
    on<ThemeChanged>(
      _onThemeChanged,
    );
  }

  Future<void> _onThemeChanged(
      ThemeChanged event, Emitter<ThemeState> emit) async {
    if (event.status == ThemeStateStatus.bright) {
      emit(
        state.copyWith(
          status: ThemeStateStatus.bright,
          themeData: AppThemes.brightTheme,
        ),
      );
    } else if (event.status == ThemeStateStatus.dark) {
      emit(
        state.copyWith(
          status: ThemeStateStatus.dark,
          themeData: AppThemes.darkTheme,
        ),
      );
    } else if (event.status == ThemeStateStatus.system) {
      var brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      emit(
        state.copyWith(
          status: ThemeStateStatus.system,
          themeData: isDarkMode ? AppThemes.darkTheme : AppThemes.brightTheme,
        ),
      );
    }
  }
}
