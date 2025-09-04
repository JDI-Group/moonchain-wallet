import 'dart:async';

import 'package:moonchain_wallet/core/core.dart';
import 'package:mxc_logic/mxc_logic.dart';

class ReporterUseCase extends ReactiveUseCase {
  ReporterUseCase(
    this._repository,
  );

  final Web3Repository _repository;

  Future<String> getLastReportData() async {
    return await _repository.reporterRepository.getLastReportData();
  }
}
