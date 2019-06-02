// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Middleware that manages interactions between ui and api

import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:berlin_transport/data/data.dart';
import 'package:berlin_transport/data/api.dart' as api;

/// Journey data
class JourneyNotifier with ChangeNotifier {
  // Depature data
  Place _departure;
  Place get departure => _departure;
  set departure(Place place) {
    _departure = place;
    _fetchJourneys();
    notifyListeners();
  }

  // Arrival data
  Place _arrival;
  Place get arrival => _arrival;
  set arrival(Place place) {
    _arrival = place;
    _fetchJourneys();
    notifyListeners();
  }

  // Journey data
  List<Journey> _journeys;
  List<Journey> get journeys => _journeys;
  void _fetchJourneys() async {
    if (_departure != null && _arrival != null) {
      _journeys = await api.journey(_departure.id, _arrival.id);
      notifyListeners();
    }
  }
}

/// Preferences
class PrefsNotifier with ChangeNotifier {
  // Offline
  bool _offline = false;
  bool get offline => _offline;
  set offline(bool value) {
    _offline = offline;
    notifyListeners();
  }

  // Locale
  static const Map<int, Locale> supportedLanguages = {
    0: const Locale('en'),
    1: const Locale('de'),
  };

  // The selector value, which maps to supportedLanguages
  int _localeSelector = 0;
  int get localeSelector => _localeSelector;
  set localeSelector(int val) {
    assert(val >= 0 && val <= 1);
    _localeSelector = val;
    _locale = supportedLanguages[val];
    notifyListeners();
  }

  Locale _locale;
  Locale get locale => _locale;
}

/// App state
class AppStateNotifier with ChangeNotifier {
  // Splash screen
  bool _showSplash = true;
  bool get showSplash => _showSplash;

  void hideSplash() {
    _showSplash = false;
    notifyListeners();
  }

  void resetSplash() {
    _showSplash = true;
    notifyListeners();
  }
}