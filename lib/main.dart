import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:jellyjelly/routing/app_router.dart';
import 'package:jellyjelly/utils/colors.dart';
import 'package:jellyjelly/utils/functions.dart';
import 'package:jellyjelly/view_models/BasicStates.dart';
import 'package:provider/provider.dart';

final GetIt locator = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void setupLocator() {
  locator.registerLazySingleton(() => BasicState());
}

Future<void> main() async {
  setupLocator();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => locator<BasicState>()),
    ],
        child : MaterialApp.router(
            debugShowCheckedModeBanner: false,
            color: Colors.white,
            scaffoldMessengerKey: CustomSnackbar.messengerKey,
            routerDelegate: AppRouter().router.routerDelegate,
            routeInformationParser: AppRouter().router.routeInformationParser,
            routeInformationProvider: AppRouter().router.routeInformationProvider,
            title: 'jelly',
            theme: ThemeData(
                fontFamily: "Roboto",
                colorScheme: ColorScheme.light().copyWith(
                    surface: CustomColors.transparent,
                    surfaceTint: CustomColors.transparent
                ),
                bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
                canvasColor: Colors.transparent
            )
        ));
  }
}