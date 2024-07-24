import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class TraceRepositoryInterface {
  Future<dynamic> getTraces({
    required Pagination pagination,
    String? objectId,
    String? subjectId,
    String? group,
    String? type,
    List<String>? params,
  });

  Future<dynamic> createAction(TraceRequest traceRequest);
}
