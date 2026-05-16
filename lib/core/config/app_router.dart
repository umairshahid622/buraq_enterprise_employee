// core/config/app_router.dart

import 'package:buraq_enterprise_employee/core/config/app_session.dart';
import 'package:buraq_enterprise_employee/core/config/router_refresh_stream.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/layouts/auth_layout.dart';
import 'package:buraq_enterprise_employee/layouts/main_layout.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/auth/login_screen.dart';
import 'package:buraq_enterprise_employee/screen/widgets/add_expense/add_expense_screen_widget.dart';
import 'package:buraq_enterprise_employee/screen/widgets/home/manage_expense_screen_widget.dart';
import 'package:buraq_enterprise_employee/screen/widgets/home/home_screen_widget.dart';
import 'package:buraq_enterprise_employee/screen/widgets/profile/profile_screen_widget.dart';
import 'package:buraq_enterprise_employee/screen/widgets/my_stats/my_stats_screen.dart';
import 'package:buraq_enterprise_employee/screen/widgets/splash/splash_screen_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: RouterRefreshStream(),
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreenWidget()),
    ShellRoute(
      navigatorKey: AppConstants.rootNavigatorKey,
      builder: (context, state, child) => AuthLayout(child: child),
      routes: [
        GoRoute(
          path: '/auth/login',
          pageBuilder: (_, _) => NoTransitionPage(
            child: Builder(
              builder: (context) {
                return const LoginScreen();
              },
            ),
          ),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(
          key: ValueKey(state.uri.toString()),
          navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: HomeScreenWidget()),
              routes: [
                GoRoute(
                  path: "manage-expense",
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: ManageExpenseScreenWidget(
                        expenseItem: state.extra as AddExpenseModel,
                      )),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add-expense',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: AddExpenseScreenWidget()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my-stats',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: MyStatsScreenWidget()),
              
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: ProfileScreenWidget()),
              
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final bool isSplash = state.matchedLocation == '/splash';
    final user = FirebaseAuth.instance.currentUser;

    // 1. If we haven't finished the Splash logic, stay on Splash
    if (!appSession.isReady) {
      return '/splash';
    }

    // 2. Once ready, check Auth
    if (user == null) {
      return state.matchedLocation.startsWith('/auth') ? null : '/auth/login';
    }

    // 3. If logged in and on Splash/Login, go Home
    if (isSplash || state.matchedLocation.startsWith('/auth')) {
      return '/home';
    }

    return null;
  },
);
