import 'package:bloc/bloc.dart';
import 'package:islamic_habits/utility/Themes/app_themes.dart';
import 'package:islamic_habits/utility/shared_prefrences_helper.dart';
import 'bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: appThemeData['PurpleDark']!)) {
    on<ThemeChanged>((event, emit) {
      SharedPreferencesHelper.setAppTheme(event.theme);
      emit(ThemeState(themeData: appThemeData[event.theme]!));
    });
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final saved = await SharedPreferencesHelper.getAppTheme();
    if (saved != null && appThemeData.containsKey(saved)) {
      add(ThemeChanged(theme: saved));
    }
  }
}
