import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/components/ui/theme.dart';

class VimPageRoute {
  static slideIn<T>(
    Widget widget, {
    RouteSettings settings,
    maintainState: true,
    bool fullscreenDialog: false,
  }) {
    return CupertinoPageRoute<T>(
      builder: (BuildContext context) => VimTheme(child: widget),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static fadeIn<T>(
    Widget widget, {
    RouteSettings settings,
    maintainState: true,
  }) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => VimTheme(child: widget),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(opacity: animation, child: child);
      },
      settings: settings,
      maintainState: maintainState,
    );
  }
}

class VimNavigate {
  VimNavigate(
    BuildContext context,
    Widget widget, {
    String name,
    RouteSettings settings,
    maintainState: true,
    bool fullscreenDialog: false,
    hostRoute,
  }) {
    Navigator.push(
      context,
      VimNavigate.slideIn(
        widget,
        name: name,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        hostRoute: hostRoute,
      ),
    );
  }
  static fadeIn<T>(
    Widget widget, {
    String name,
    RouteSettings settings,
    maintainState: true,
  }) {
    var _settings = name != null ? new RouteSettings(name: name) : settings;
    return VimPageRoute.fadeIn<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
    );
  }

  static slideIn<T>(
    Widget widget, {
    String name,
    RouteSettings settings,
    maintainState: true,
    bool fullscreenDialog: false,
    hostRoute,
  }) {
    var _settings = name != null ? new RouteSettings(name: name) : settings;
    return VimPageRoute.slideIn<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

class VimNavigateRoute<T> extends MaterialPageRoute<T> {
  VimNavigateRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> positionIn(Animation<double> animation) =>
        new Tween<Offset>(
          // begin: const Offset(1.0, 0.0),
          // begin: const Offset(0.0, 1.0),
          begin: const Offset(0.0, 0.3),
          end: Offset.zero,
        ).animate(animation);

    // Animation<Offset> positionOut(Animation<double> animation) => new Tween<Offset>(
    //       begin: Offset.zero,
    //       end: Offset.zero,
    //     ).animate(animation);

    if (settings.name == '/splashscreen') return child;
    // return new FadeTransition(opacity: animation, child: child);
    // return new SlideTransition(position: positionIn(animation), child: child);
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(position: positionIn(animation), child: child),
    );
    // return new SlideTransition(
    //   position: positionIn(animation),
    //   child: new SlideTransition(position: positionOut(secondaryAnimation), child: child),
    // );
  }
}
