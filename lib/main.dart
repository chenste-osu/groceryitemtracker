import 'package:groceryitemtracker/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GIT());
}

class GIT extends StatelessWidget {
  const GIT({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Item Tracker',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      navigatorObservers: <NavigatorObserver>[GIT.observer],
      home: ListScreen(analytics: GIT.analytics, observer: GIT.observer),
    );
  }
}
