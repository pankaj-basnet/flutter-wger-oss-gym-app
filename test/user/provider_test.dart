/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c)  2026 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/user.dart';

import '../fixtures/fixture_reader.dart';
import 'provider_test.mocks.dart';

@GenerateMocks([UserProfileRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Profile tProfile = Profile.fromJson(
    jsonDecode(fixture('user/userprofile_response.json')) as Map<String, dynamic>,
  );

  late MockUserProfileRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    mockRepo = MockUserProfileRepository();
    when(mockRepo.fetchProfile()).thenAnswer((_) async => tProfile);

    container = ProviderContainer(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('profile', () {
    test('build fetches the profile from the repository', () async {
      final profile = await container.read(userProfileProvider.future);

      expect(profile, isNotNull);
      expect(profile!.username, 'admin');
      expect(profile.emailVerified, true);
      expect(profile.email, 'me@example.com');
      expect(profile.isTrustworthy, true);
      verify(mockRepo.fetchProfile()).called(1);
    });

    test('clear() resets the profile to null', () async {
      await container.read(userProfileProvider.future);
      expect(container.read(userProfileProvider).value, isNotNull);

      container.read(userProfileProvider.notifier).clear();
      expect(container.read(userProfileProvider).value, isNull);
    });

    test('saveProfile delegates to the repository', () async {
      await container.read(userProfileProvider.future);
      when(mockRepo.saveProfile(any)).thenAnswer((_) async {});

      await container.read(userProfileProvider.notifier).saveProfile();

      verify(mockRepo.saveProfile(tProfile)).called(1);
    });

    test('verifyEmail delegates to the repository', () async {
      await container.read(userProfileProvider.future);
      when(mockRepo.verifyEmail()).thenAnswer((_) async {});

      await container.read(userProfileProvider.notifier).verifyEmail();

      verify(mockRepo.verifyEmail()).called(1);
    });
  });

  group('dashboard config', () {
    test('initial config is default (all visible, default order)', () async {
      final settings = await container.read(appSettingsProvider.future);
      final items = settings.dashboardItems;

      expect(items.allWidgets.length, DashboardWidget.values.length);
      expect(
        items.allWidgets,
        orderedEquals([
          DashboardWidget.networkInfo,
          DashboardWidget.trophies,
          DashboardWidget.routines,
          DashboardWidget.nutrition,
          DashboardWidget.weight,
          DashboardWidget.measurements,
          DashboardWidget.calendar,
        ]),
      );
      expect(items.isWidgetVisible(DashboardWidget.routines), true);
    });

    test('toggling visibility updates state', () async {
      await container.read(appSettingsProvider.future);
      final notifier = container.read(appSettingsProvider.notifier);

      await notifier.setWidgetVisible(DashboardWidget.routines, false);
      var items = container.read(appSettingsProvider).requireValue.dashboardItems;
      expect(items.isWidgetVisible(DashboardWidget.routines), false);

      await notifier.setWidgetVisible(DashboardWidget.routines, true);
      items = container.read(appSettingsProvider).requireValue.dashboardItems;
      expect(items.isWidgetVisible(DashboardWidget.routines), true);
    });

    test('reordering updates order', () async {
      await container.read(appSettingsProvider.future);
      final notifier = container.read(appSettingsProvider.notifier);

      final initial = container
          .read(appSettingsProvider)
          .requireValue
          .dashboardItems
          .visibleWidgets;
      final initialFirst = initial[0];
      final initialSecond = initial[1];

      // move first to second position (ReorderableListView semantics)
      await notifier.setDashboardOrder(0, 2);

      final updated = container
          .read(appSettingsProvider)
          .requireValue
          .dashboardItems
          .visibleWidgets;
      expect(updated[0], initialSecond);
      expect(updated[1], initialFirst);
    });

    test('loads config from prefs when present', () async {
      // Use a dedicated in-memory prefs instance to avoid bleed from other tests.
      SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
      final prefs = SharedPreferencesAsync();
      final customConfig = [
        {'widget': 'nutrition', 'visible': true},
        {'widget': 'routines', 'visible': false},
      ];
      await prefs.setString(PREFS_DASHBOARD_CONFIG, jsonEncode(customConfig));

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 100));

      // assert
      expect(newProvider.allDashboardWidgets[0], DashboardWidget.trophies);
      expect(newProvider.allDashboardWidgets[1], DashboardWidget.nutrition);
      expect(newProvider.allDashboardWidgets[2], DashboardWidget.routines);
      expect(newProvider.allDashboardWidgets[3], DashboardWidget.weight);

      expect(newProvider.isDashboardWidgetVisible(DashboardWidget.nutrition), true);
      expect(newProvider.isDashboardWidgetVisible(DashboardWidget.routines), false);

      expect(newProvider.isDashboardWidgetVisible(DashboardWidget.weight), true);
      expect(newProvider.isDashboardWidgetVisible(DashboardWidget.trophies), true);
    });
  });

  group('user locale', () {
    test('defaults to null when no override saved', () async {
      // act
      await Future.delayed(const Duration(milliseconds: 50));

      // assert: null means "follow system locale"
      expect(userProvider.userLocale, null);
    });

    test('setUserLocale persists language-only code to prefs', () async {
      // act
      await userProvider.setUserLocale(const Locale('pl'));

      // assert
      expect(userProvider.userLocale, const Locale('pl'));
      final stored = await SharedPreferencesAsync().getString(PREFS_USER_LOCALE);
      expect(stored, 'pl');
    });

    test('setUserLocale persists country-coded locale (pt_BR)', () async {
      // act
      await userProvider.setUserLocale(const Locale('pt', 'BR'));

      // assert
      final stored = await SharedPreferencesAsync().getString(PREFS_USER_LOCALE);
      expect(stored, 'pt_BR');
    });

    test('setUserLocale persists script-coded locale (zh_Hant)', () async {
      // act
      await userProvider.setUserLocale(const Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hant',
      ));

      // assert
      final stored = await SharedPreferencesAsync().getString(PREFS_USER_LOCALE);
      expect(stored, 'zh_Hant');
    });

    test('setUserLocale(null) clears the stored override', () async {
      // arrange
      await userProvider.setUserLocale(const Locale('de'));
      expect(await SharedPreferencesAsync().getString(PREFS_USER_LOCALE), 'de');

      // act
      await userProvider.setUserLocale(null);

      // assert
      expect(userProvider.userLocale, null);
      expect(await SharedPreferencesAsync().getString(PREFS_USER_LOCALE), null);
    });

    test('setUserLocale notifies listeners', () async {
      // arrange
      var notifyCount = 0;
      userProvider.addListener(() => notifyCount++);

      // act
      await userProvider.setUserLocale(const Locale('fr'));

      // assert
      expect(notifyCount, greaterThanOrEqualTo(1));
    });

    test('loads previously stored language-only locale on construction', () async {
      // arrange
      final prefs = SharedPreferencesAsync();
      await prefs.setString(PREFS_USER_LOCALE, 'de');

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 50));

      // assert
      expect(newProvider.userLocale, const Locale('de'));
    });

    test('loads previously stored country-coded locale (pt_BR)', () async {
      // arrange
      final prefs = SharedPreferencesAsync();
      await prefs.setString(PREFS_USER_LOCALE, 'pt_BR');

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 50));

      // assert
      expect(newProvider.userLocale?.languageCode, 'pt');
      expect(newProvider.userLocale?.countryCode, 'BR');
    });

    test('loads previously stored script-coded locale (zh_Hant)', () async {
      // arrange
      final prefs = SharedPreferencesAsync();
      await prefs.setString(PREFS_USER_LOCALE, 'zh_Hant');

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 50));

      // assert
      expect(newProvider.userLocale?.languageCode, 'zh');
      expect(newProvider.userLocale?.scriptCode, 'Hant');
    });

    test('falls back to language-only match for unknown country code', () async {
      // arrange: "pl_XX" is not a supported subtag; should fall back to "pl"
      final prefs = SharedPreferencesAsync();
      await prefs.setString(PREFS_USER_LOCALE, 'pl_XX');

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 50));

      // assert
      expect(newProvider.userLocale, const Locale('pl'));
    });

    test('returns null for completely unsupported locale tag', () async {
      // arrange
      final prefs = SharedPreferencesAsync();
      await prefs.setString(PREFS_USER_LOCALE, 'xx_YY');

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 50));

      // assert
      expect(newProvider.userLocale, null);
    });

    test('returns null for empty stored value', () async {
      // arrange
      final prefs = SharedPreferencesAsync();
      await prefs.setString(PREFS_USER_LOCALE, '');

      // act
      final newProvider = UserProvider(mockWgerBaseProvider, prefs: prefs);
      await Future.delayed(const Duration(milliseconds: 50));

      // assert
      expect(newProvider.userLocale, null);
    });

    test('clear() does NOT reset the user locale (preference survives logout)', () async {
      // arrange
      await userProvider.setUserLocale(const Locale('it'));
      expect(userProvider.userLocale, const Locale('it'));

      // act
      userProvider.clear();

      // assert: clear() resets profile but locale preference is intentionally kept
      expect(userProvider.userLocale, const Locale('it'));
    });
  });

}
