import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'trace_repository_interface.dart';

class TraceRepositoryImpl extends TraceRepositoryInterface {
  @override
  Future<dynamic> getTraces(
      {required Pagination pagination,
      String? objectId,
      String? subjectId,
      String? group,
      String? type,
      List<String>? params}) async {
    var url =
        tracesUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (objectId != null) {
      url += '&object_id=$objectId';
    }

    if (subjectId != null) {
      url += '&subject_id=$subjectId';
    }

    if (group != null) {
      url += '&group=$group';
    }

    if (type != null) {
      url += '&type=$type';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Trace> traces = [];

    try {
      json['traces'].forEach((element) {
        traces.add(Trace.fromJson(element));
      });
      return traces;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createAction(TraceRequest traceRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      traceActionCreateUrl,
      traceRequest.toJson(),
    );

    try {
      return Trace.fromJson(json["do_action"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
