import 'package:get/get.dart';
import 'package:three_bhai/repositories/history_repository.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/search_record.dart';

enum HistoryStatus { loading, loaded, failure }

class HistoryState {
  const HistoryState({
    this.status = HistoryStatus.loading,
    this.records = const [],
    this.errorMessage,
  });

  final HistoryStatus status;
  final List<SearchRecord> records;
  final String? errorMessage;
}

class HistoryController extends GetxController {
  // Lecture 2: Rx owns state; Obx reads it and rebuilds the UI.
  final observable = const HistoryState().obs;
  HistoryState get state => observable.value;

  void _updateState(HistoryState next) {
    // Lecture 2 lifecycle: never notify a screen after its route is disposed.
    if (!isClosed) observable.value = next;
  }

  HistoryController(this._repository);

  final HistoryRepository _repository;

  Future<void> load() async {
    _updateState(const HistoryState());
    try {
      _updateState(
        HistoryState(
          status: HistoryStatus.loaded,
          records: await _repository.getHistory(),
        ),
      );
    } on Failure catch (e) {
      _updateState(
        HistoryState(status: HistoryStatus.failure, errorMessage: e.message),
      );
    } catch (_) {
      _updateState(
        const HistoryState(
          status: HistoryStatus.failure,
          errorMessage: 'Could not load your history.',
        ),
      );
    }
  }

  Future<void> delete(String id) async {
    _updateState(
      HistoryState(
        status: HistoryStatus.loaded,
        records: state.records.where((r) => r.id != id).toList(),
      ),
    );
    try {
      await _repository.delete(id);
    } catch (_) {
      await load(); // restore the truth if the delete failed
    }
  }

  Future<void> clear() async {
    _updateState(const HistoryState(status: HistoryStatus.loaded));
    try {
      await _repository.clear();
    } catch (_) {
      await load();
    }
  }
}
