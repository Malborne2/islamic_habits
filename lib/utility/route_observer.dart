import 'package:flutter/material.dart';

// Lets a screen rebuild itself when a route pushed on top of it (e.g.
// Settings) is popped back to it, so changes made there (like prayer time
// corrections) show up immediately instead of needing an unrelated
// navigation to force a rebuild.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();
