import 'package:flutter_test/flutter_test.dart';
import 'package:stop_watch/presentation/viewmodels/home_viewmodel.dart';

void main() {
  group('HomeViewModel Total Duration & Presets Tests', () {
    test('Calculates totalSeconds accurately without rest after final round', () {
      final vm = HomeViewModel();
      // Tabata defaults: 8 rounds, 10s prep, 20s work, 10s rest
      vm.applyPreset(HomeViewModel.presets.firstWhere((p) => p.type == WorkoutPresetType.tabata));

      // Prep (10s) + 8 rounds of work (8 * 20s = 160s) + 7 rests (7 * 10s = 70s) = 240s (4 mins)
      // The old flawed formula would have given 250s (4m 10s) due to counting 8 rests.
      expect(vm.totalSeconds, equals(240));
    });

    test('Single round workout has 0 rests in totalSeconds', () {
      final vm = HomeViewModel();
      vm.setPrepTime(0, 10);
      vm.setWorkoutTime(1, 0); // 60s
      vm.setRestTime(0, 30);   // 30s
      vm.setTotalRounds(1);

      // 10s prep + 1 round * 60s + 0 rests = 70s
      expect(vm.totalSeconds, equals(70));
    });

    test('Applying Boxing preset sets 3m work, 1m rest, 3 rounds', () {
      final vm = HomeViewModel();
      final boxingPreset = HomeViewModel.presets.firstWhere((p) => p.type == WorkoutPresetType.boxing);
      vm.applyPreset(boxingPreset);

      expect(vm.selectedPreset, equals(WorkoutPresetType.boxing));
      expect(vm.workoutMinutes, equals(3));
      expect(vm.restMinutes, equals(1));
      expect(vm.totalRounds, equals(3));
      // Prep (10s) + 3 rounds * 180s (540s) + 2 rests * 60s (120s) = 670s (11m 10s)
      expect(vm.totalSeconds, equals(670));
    });

    test('Manually modifying a value sets selectedPreset to custom', () {
      final vm = HomeViewModel();
      vm.applyPreset(HomeViewModel.presets.first);
      expect(vm.selectedPreset, equals(WorkoutPresetType.tabata));

      vm.setWorkoutTime(0, 25);
      expect(vm.selectedPreset, equals(WorkoutPresetType.custom));
    });
  });
}
