import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ai/view/ai_page.dart';
import '../features/ai/view/ai_breakdown_page.dart';
import '../features/ai/view/ai_ask_page.dart';
import '../features/ai/view/ai_daily_review_page.dart';
import '../features/ai/view/ai_quick_note_page.dart';
import '../features/ai/view/ai_today_plan_page.dart';
import '../features/ai/view/ai_weekly_review_page.dart';
import '../features/focus/view/focus_page.dart';
import '../features/notes/view/notes_page.dart';
import '../features/notes/view/note_detail_page.dart';
import '../features/settings/view/ai_settings_page.dart';
import '../features/settings/view/appearance_settings_page.dart';
import '../features/settings/view/data_settings_page.dart';
import '../features/settings/view/pomodoro_settings_page.dart';
import '../features/settings/view/privacy_page.dart';
import '../features/settings/view/settings_page.dart';
import '../features/tasks/view/tasks_page.dart';
import '../features/tasks/view/task_detail_page.dart';
import '../features/today/view/today_page.dart';
import 'home_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/today',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai',
                builder: (context, state) => const AiPage(),
                routes: [
                  GoRoute(
                    path: 'quick-note',
                    builder: (context, state) => const AiQuickNotePage(),
                  ),
                  GoRoute(
                    path: 'breakdown',
                    builder: (context, state) => AiBreakdownPage(
                      initialInput: state.uri.queryParameters['input'],
                    ),
                  ),
                  GoRoute(
                    path: 'ask',
                    builder: (context, state) => const AiAskPage(),
                  ),
                  GoRoute(
                    path: 'today-plan',
                    builder: (context, state) => const AiTodayPlanPage(),
                  ),
                  GoRoute(
                    path: 'daily',
                    builder: (context, state) => const AiDailyReviewPage(),
                  ),
                  GoRoute(
                    path: 'weekly',
                    builder: (context, state) => const AiWeeklyReviewPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notes',
                builder: (context, state) => const NotesPage(),
                routes: [
                  GoRoute(
                    path: ':noteId',
                    builder: (context, state) =>
                        NoteDetailPage(noteId: state.pathParameters['noteId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                builder: (context, state) => const TodayPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksPage(),
                routes: [
                  GoRoute(
                    path: ':taskId',
                    builder: (context, state) =>
                        TaskDetailPage(taskId: state.pathParameters['taskId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/focus',
                builder: (context, state) =>
                    FocusPage(taskId: state.uri.queryParameters['taskId']),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/data',
        builder: (context, state) => const DataSettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/privacy',
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/ai',
        builder: (context, state) => const AiSettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/pomodoro',
        builder: (context, state) => const PomodoroSettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings/appearance',
        builder: (context, state) => const AppearanceSettingsPage(),
      ),
    ],
  );
});
