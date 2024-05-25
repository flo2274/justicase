import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/views/pages/case_page.dart';
import 'package:mobile_anw/views/pages/create-case_page.dart';
import 'package:mobile_anw/views/pages/search_page.dart';
import 'package:mobile_anw/views/pages/home_page.dart';
import 'package:mobile_anw/views/pages/grouping_page.dart';
import 'package:mobile_anw/views/pages/scaffold_with_nested_navigation.dart';

// private navigators (underscore makes it private)
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
final _shellNavigatorCaseKey = GlobalKey<NavigatorState>(debugLabel: 'shellCase');

final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
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
              /*routes: [
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const DetailsScreen(label: 'DetailHome'),
                ),
              ],*/
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
              routes: [
                GoRoute(
                  path: 'grouping',
                  builder: (context, state) => const GroupingPage(),
                ),
                GoRoute(
                  path: 'createCase',
                  builder: (context, state) => const CreateCasePage(),
                ),
              ],
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
                  path: 'grouping',
                  builder: (context, state) => const GroupingPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
