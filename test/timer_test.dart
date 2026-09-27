import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch/data/repositories/settings_repository_impl.dart';
import 'package:stop_watch/data/services/audio_service.dart';
import 'package:stop_watch/data/services/vibration_service.dart';
import 'package:stop_watch/presentation/viewmodels/settings_viewmodel.dart';
import 'package:stop_watch/presentation/viewmodels/standalone_timer_viewmodel.dart';

class MockAudioService implements AudioService {
  int playTimerCompleteCallCount = 0;
  int playBeepCallCount = 0;

  @override
  void updateEnabled(bool enabled) {}

  @override
  Future<void> updateLanguage(String languageName) async {}

  @override
  Future<void> speakTick(String number) async {}

  @override
  Future<void> speakGo() async {}

  @override
  Future<void> speakRest() async {}

  @override
  Future<void> speakCongrats() async {}

  @override
  Future<void> speakCountdown(String key) async {}

  @override
  Future<void> stopSpeaking() async {}

  @override
  Future<void> playTimerComplete() async {
    playTimerCompleteCallCount++;
  }

  @override
  Future<void> playBeep() async {
    playBeepCallCount++;
  }

  @override
  Future<void> stop() async {}

  @override
  void dispose() {}
}

class MockVibrationService implements VibrationService {
  int vibrateTimerCompleteCallCount = 0;
  int vibrateActionCallCount = 0;

  @override
  void updateEnabled(bool enabled) {}

  @override
  Future<void> vibrateTimerComplete() async {
    vibrateTimerCompleteCallCount++;
  }

  @override
  Future<void> vibrateAction() async {
    vibrateActionCallCount++;
  }

  @override
  Future<void> vibrate({int duration = 500, int amplitude = -1}) async {}

  @override
  Future<void> vibrateImpact() async {}

  @override
  Future<void> vibrateRestStart() async {}

  @override
  Future<void> vibrateCongrats() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late SettingsRepositoryImpl settingsRepo;
  late SettingsViewModel settingsViewModel;
  late MockAudioService mockAudioService;
  late MockVibrationService mockVibrationService;
  late StandaloneTimerViewModel timerViewModel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    settingsRepo = SettingsRepositoryImpl(prefs);
    settingsViewModel = SettingsViewModel(settingsRepo);
    mockAudioService = MockAudioService();
    mockVibrationService = MockVibrationService();

    timerViewModel = StandaloneTimerViewModel(
      settingsViewModel: settingsViewModel,
      audioService: mockAudioService,
      vibrationService: mockVibrationService,
    );
  });

  tearDown(() {
    timerViewModel.dispose();
  });

  group('StandaloneTimerViewModel - Countdown Mode', () {
    test('Initial countdown state is idle and formatted correctly', () {
      expect(timerViewModel.mode, StandaloneTimerMode.countdown);
      expect(timerViewModel.status, StandaloneTimerStatus.idle);
      expect(timerViewModel.configuredDuration.inMinutes, 10);
      expect(timerViewModel.formattedTime, '10:00');
      expect(timerViewModel.isIdle, isTrue);
      expect(timerViewModel.isRunning, isFalse);
    });

    test('Set duration updates remaining duration when idle', () {
      timerViewModel.setCountdownDuration(const Duration(minutes: 5, seconds: 30));
      expect(timerViewModel.configuredDuration, const Duration(minutes: 5, seconds: 30));
      expect(timerViewModel.currentDuration, const Duration(minutes: 5, seconds: 30));
      expect(timerViewModel.formattedTime, '05:30');
    });

    test('Start changes status to running and pause/resume/reset work', () async {
      timerViewModel.setCountdownDuration(const Duration(seconds: 10));
      timerViewModel.start();

      expect(timerViewModel.status, StandaloneTimerStatus.running);
      expect(timerViewModel.isRunning, isTrue);

      timerViewModel.pause();
      expect(timerViewModel.status, StandaloneTimerStatus.paused);
      expect(timerViewModel.isPaused, isTrue);

      timerViewModel.resume();
      expect(timerViewModel.status, StandaloneTimerStatus.running);

      timerViewModel.reset();
      expect(timerViewModel.status, StandaloneTimerStatus.idle);
      expect(timerViewModel.formattedTime, '00:10');
    });

    test('Countdown completion stops at 00:00 and triggers feedback without restarting', () async {
      // Set to 1 second countdown
      timerViewModel.setCountdownDuration(const Duration(seconds: 1));
      timerViewModel.start();

      // Wait for countdown to tick down and complete
      await Future.delayed(const Duration(milliseconds: 1200));

      expect(timerViewModel.status, StandaloneTimerStatus.completed);
      expect(timerViewModel.isCompleted, isTrue);
      expect(timerViewModel.currentDuration, Duration.zero);
      expect(timerViewModel.formattedTime, '00:00');
      expect(mockAudioService.playTimerCompleteCallCount, 1);
      expect(mockVibrationService.vibrateTimerCompleteCallCount, 1);

      // Verify it does not auto restart
      await Future.delayed(const Duration(milliseconds: 500));
      expect(timerViewModel.status, StandaloneTimerStatus.completed);
      expect(timerViewModel.formattedTime, '00:00');

      // Reset brings it back to configured duration
      timerViewModel.reset();
      expect(timerViewModel.status, StandaloneTimerStatus.idle);
      expect(timerViewModel.formattedTime, '00:01');
    });
  });

  group('StandaloneTimerViewModel - Stopwatch Mode', () {
    test('Switching to stopwatch mode resets to 00:00', () {
      timerViewModel.setMode(StandaloneTimerMode.stopwatch);
      expect(timerViewModel.mode, StandaloneTimerMode.stopwatch);
      expect(timerViewModel.status, StandaloneTimerStatus.idle);
      expect(timerViewModel.currentDuration, Duration.zero);
      expect(timerViewModel.formattedTime, '00:00');
    });

    test('Stopwatch starts, accumulates elapsed time, pauses, resumes, and resets', () async {
      timerViewModel.setMode(StandaloneTimerMode.stopwatch);
      timerViewModel.start();

      expect(timerViewModel.status, StandaloneTimerStatus.running);

      await Future.delayed(const Duration(milliseconds: 400));
      expect(timerViewModel.currentDuration.inMilliseconds, greaterThanOrEqualTo(300));

      timerViewModel.pause();
      expect(timerViewModel.status, StandaloneTimerStatus.paused);
      final elapsedWhenPaused = timerViewModel.currentDuration;

      await Future.delayed(const Duration(milliseconds: 200));
      // Should not have increased while paused
      expect(timerViewModel.currentDuration, elapsedWhenPaused);

      timerViewModel.resume();
      expect(timerViewModel.status, StandaloneTimerStatus.running);

      timerViewModel.reset();
      expect(timerViewModel.status, StandaloneTimerStatus.idle);
      expect(timerViewModel.currentDuration, Duration.zero);
      expect(timerViewModel.formattedTime, '00:00');
    });
  });

  group('StandaloneTimerViewModel - Time Formatting', () {
    test('Formats under 1 hour as MM:SS and >= 1 hour as HH:MM:SS', () {
      timerViewModel.setCountdownDuration(const Duration(seconds: 45));
      expect(timerViewModel.formattedTime, '00:45');

      timerViewModel.setCountdownDuration(const Duration(minutes: 9, seconds: 42));
      expect(timerViewModel.formattedTime, '09:42');

      timerViewModel.setCountdownDuration(const Duration(hours: 1, minutes: 2, seconds: 3));
      expect(timerViewModel.formattedTime, '01:02:03');
    });
  });
}
