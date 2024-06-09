import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
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

  Future<dynamic> createAction(TraceRequest traceRequest) async {
    dynamic json = await WebService().post(
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
