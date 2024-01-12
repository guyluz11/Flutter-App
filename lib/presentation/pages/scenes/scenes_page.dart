import 'dart:collection';
import 'dart:ui';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';
import 'package:cybearjinni/domain/connections_service.dart';
import 'package:cybearjinni/presentation/atoms/atoms.dart';
import 'package:cybearjinni/presentation/molecules/molecules.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class ScenesPage extends StatefulWidget {
  const ScenesPage(this.area);

  final AreaEntity area;

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> {
  HashMap<String, SceneCbjEntity>? scenes;

  @override
  void initState() {
    super.initState();
    _initialized();
  }

  Future<void> _initialized() async {
    final HashMap<String, SceneCbjEntity> scenecsTemp =
        await ConnectionsService.instance.getScenes();

    final HashMap<String, SceneCbjEntity> scenesInArea = HashMap.fromEntries(
      widget.area.areaScenesId.getOrCrash().map((e) {
        final SceneCbjEntity? scene = scenecsTemp[e];
        if (scene == null) {
          return null;
        }
        return MapEntry(scene.uniqueId.getOrCrash(), scene);
      }).nonNulls,
    );

    setState(() {
      scenes = scenesInArea;
    });
  }

  /// Execute when user press the icon in top right side
  void userCogFunction(BuildContext context) {
    showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const TextAtom(
            '➕ Add Automation',
            style: TextStyle(color: Colors.green, fontSize: 23),
          ),
          onPressed: (_) {},
        ),
        BottomSheetAction(
          title: const TextAtom(
            '⚙️ Scenes Settings',
            style: TextStyle(color: Colors.blueGrey, fontSize: 23),
          ),
          onPressed: (_) {},
        ),
      ],
    );
  }

  void leftIconFunction(BuildContext context) {
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (scenes == null) {
      return Scaffold(
        body: LoadingPageMolecule(),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.area.background.getOrCrash(),
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: ColoredBox(
            color: Colors.black12,
            child: Column(
              children: [
                TopBarMolecule(
                  pageName: 'Scenes_In_Folder',
                  rightIconFunction: userCogFunction,
                  leftIcon: FontAwesomeIcons.arrowLeft,
                  leftIconFunction: leftIconFunction,
                  // rightSecondIcon: FontAwesomeIcons.magnifyingGlass,
                ),
                Expanded(
                  child: ScenesGridMolecule(
                    scenes: scenes!.values.toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
