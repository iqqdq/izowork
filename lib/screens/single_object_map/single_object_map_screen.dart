import 'package:flutter/material.dart';
import 'package:izowork/models/single_object_map_view_model.dart';
import 'package:izowork/screens/single_object_map/single_object_map_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:izowork/entities/response/object.dart';

class SingleObjectMapScreenWidget extends StatelessWidget {
  final Object object;

  const SingleObjectMapScreenWidget({Key? key, required this.object})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SingleObjectMapViewModel(object),
        child: const SingleObjectMapScreenBodyWidget());
  }
}
