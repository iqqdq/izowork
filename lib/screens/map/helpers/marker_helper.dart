import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

class MarkerHelper {
  Future<BitmapDescriptor> getObjectMarkerBitmap(
    int size,
    Cluster<Place> cluster,
  ) async {
    double newSize =
        Platform.isAndroid ? size.toDouble() / 1.75 : size.toDouble();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = cluster.items.first.color;
    final Paint paint2 = Paint()..color = HexColors.white;

    final Path path1 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          0.0,
          0.0,
          newSize,
          newSize,
          const Radius.elliptical(
            10.0,
            10.0,
          ),
        ),
      );

    final Path path2 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          8.0,
          8.0,
          newSize - 8.0,
          newSize - 8.0,
          const Radius.elliptical(
            10.0,
            10.0,
          ),
        ),
      );

    final Path path3 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          16.0,
          16.0,
          newSize - 16.0,
          newSize - 16.0,
          const Radius.elliptical(
            10.0,
            10.0,
          ),
        ),
      );

    canvas.drawPath(
      Path.from(path1),
      paint1,
    );

    canvas.drawPath(
      Path.from(path2),
      paint2,
    );

    canvas.drawPath(
      Path.from(path3),
      paint1,
    );

    // LETTER
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    String title1 = cluster.count.toString();
    title1 = title1.length > 3 ? '${title1.substring(0, 2)}...' : title1;
    final String title2 = cluster.items.first.name.substring(0, 1);

    painter.text = TextSpan(
        text: cluster.isMultiple ? title1 : title2,
        style: TextStyle(
          fontSize: cluster.isMultiple
              ? title1.length >= 3
                  ? newSize / 3.0
                  : newSize / 2.0
              : newSize / 2.0,
          color: HexColors.black,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
        ));

    painter.layout();

    painter.paint(
        canvas,
        Offset(
          newSize / 2.0 - painter.width / 2.0,
          newSize / 2.0 - painter.height / 2.0,
        ));

    final img = await pictureRecorder.endRecording().toImage(
          newSize.toInt(),
          newSize.toInt(),
        );

    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> getCompanyMarkerBitmap(
    int size,
    Cluster<Place> cluster,
  ) async {
    double newSize =
        Platform.isAndroid ? size.toDouble() / 1.75 : size.toDouble();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = cluster.items.first.color;
    final Paint paint2 = Paint()..color = HexColors.white;

    // TODO: - CHANGE COMPANY MARKER TO CIRCLE

    final Path path1 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          0.0,
          0.0,
          newSize,
          newSize,
          const Radius.elliptical(
            10.0,
            10.0,
          ),
        ),
      );

    final Path path2 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          8.0,
          8.0,
          newSize - 8.0,
          newSize - 8.0,
          const Radius.elliptical(
            10.0,
            10.0,
          ),
        ),
      );

    final Path path3 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          16.0,
          16.0,
          newSize - 16.0,
          newSize - 16.0,
          const Radius.elliptical(
            10.0,
            10.0,
          ),
        ),
      );

    canvas.drawPath(
      Path.from(path1),
      paint1,
    );

    canvas.drawPath(
      Path.from(path2),
      paint2,
    );

    canvas.drawPath(
      Path.from(path3),
      paint1,
    );

    // LETTER
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    String title1 = cluster.count.toString();
    title1 = title1.length > 3 ? '${title1.substring(0, 2)}...' : title1;
    final String title2 = cluster.items.first.name.substring(0, 1);

    painter.text = TextSpan(
        text: cluster.isMultiple ? title1 : title2,
        style: TextStyle(
          fontSize: cluster.isMultiple
              ? title1.length >= 3
                  ? newSize / 3.0
                  : newSize / 2.0
              : newSize / 2.0,
          color: HexColors.black,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
        ));

    painter.layout();

    painter.paint(
        canvas,
        Offset(
          newSize / 2.0 - painter.width / 2.0,
          newSize / 2.0 - painter.height / 2.0,
        ));

    final img = await pictureRecorder.endRecording().toImage(
          newSize.toInt(),
          newSize.toInt(),
        );

    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
