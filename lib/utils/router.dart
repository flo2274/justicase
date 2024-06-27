import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/views/pages/admin-panel_page.dart';
import 'package:mobile_anw/views/pages/case/case_page.dart';
import 'package:mobile_anw/views/pages/case/create-case_page.dart';
import 'package:mobile_anw/views/pages/search_page.dart';
import 'package:mobile_anw/views/pages/home_page.dart';
import 'package:mobile_anw/views/pages/case/case-details_page.dart';
import 'package:mobile_anw/views/pages/scaffold_with_nested_navigation.dart';
import 'package:mobile_anw/views/pages/auth/registration_page.dart';
import 'package:mobile_anw/views/pages/auth/login_page.dart';
import 'dart:developer';

import '../models/case.dart';
import '../models/user.dart';
import '../views/pages/admin-details_page.dart';

// private navigators (underscore makes it private)
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
final _shellNavigatorCaseKey = GlobalKey<NavigatorState>(debugLabel: 'shellCase');

final goRouter = GoRouter(
  initialLocation: '/registration',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/registration',
      builder: (context, state) => RegistrationPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'adminPanel',
                  builder: (context, state) => const AdminPanelPage(),
                ),
                GoRoute(
                  path: 'adminDetails',
                  builder: (context, state) => AdminDetailsPage(
                    caseInfo: state.extra as Case,
                    userInfo: state.extra as User,
                  ),
                ),
              ]
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            GoRoute(
              path: '/search',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchPage(/*label: 'SearchP', detailsPath: '/search/details'*/),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCaseKey,
          routes: [
            GoRoute(
              path: '/case',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CasePage(label: 'CaseP'),
              ),
              routes: [
                GoRoute(
                  path: 'caseDetails',
                  builder: (context, state) => CaseDetailsPage(
                    caseInfo: state.extra as Case,
                  ),
                ),
                GoRoute(
                  path: 'createCase',
                  builder: (context, state) => const CreateCasePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
