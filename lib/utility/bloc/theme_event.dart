import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  final String theme;

  const ThemeChanged({required this.theme});

  @override
  List<Object?> get props => [theme];
}
