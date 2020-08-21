import './pages/home_page.dart';

import './screens/playlist_screen.dart';
import './screens/playvideo_screen.dart';
import './screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/splash_page.dart';
import './stores/login_store.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        )
      ],
      child: MaterialApp(
        home: SplashPage(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          PlaylistScreen.routeName: (ctx) => PlaylistScreen(),
          PlayvideoScreen.routeName: (ctx) => PlayvideoScreen(),
          TransactionScreen.routeName: (ctx) => TransactionScreen(),
        },
      ),
    );
  }
}
