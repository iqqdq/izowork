import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/trace_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/trace.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class TraceRepository {
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

    dynamic json = await WebService().get(url);
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

  Future<dynamic> doAction(TraceRequest traceRequest) async {
    dynamic json = await WebService().post(
      traceDoActionUrl,
      traceRequest.toJson(),
    );

    try {
      return Trace.fromJson(json["do_action"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
