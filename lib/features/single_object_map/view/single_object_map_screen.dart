import 'package:flutter/material.dart';
import 'package:izowork/features/single_object_map/view_model/single_object_map_view_model.dart';

import 'package:izowork/features/single_object_map/view/single_object_map_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:izowork/models/models.dart';

class SingleObjectMapScreenWidget extends StatelessWidget {
  final MapObject object;

  const SingleObjectMapScreenWidget({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SingleObjectMapViewModel(object),
      child: const SingleObjectMapScreenBodyWidget(),
    );
  }
}
