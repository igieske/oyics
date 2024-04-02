import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:oyics/main.dart';
import 'package:oyics/pages/add-counter.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[

    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return MyHomePage(storage: LocalDataStorage());
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'add_counter',
          builder: (BuildContext context, GoRouterState state) {
            return const AddCounterPage();
          },
        ),
      ],
    ),

  ],
);