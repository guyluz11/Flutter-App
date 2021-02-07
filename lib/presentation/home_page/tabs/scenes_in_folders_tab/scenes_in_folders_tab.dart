import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cybear_jinni/application/scenes/scenes_in_folders/scenes_in_folders_bloc.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/home_page/tabs/scene_tab/settings_page_of_scenes.dart';
import 'package:cybear_jinni/presentation/home_page/tabs/scenes_in_folders_tab/widgets/scenes_in_folders_l.dart';
import 'package:cybear_jinni/presentation/shared_widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScenesInFoldersTab extends StatelessWidget {
  /// Execute when user press the icon in top right side
  void userCogFunction(BuildContext context) {
    showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: '➕ Add Scene',
            onPressed: () {},
            textStyle: const TextStyle(color: Colors.green, fontSize: 23)),
        BottomSheetAction(
          title: '⚙️ Scenes Settings',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SettingsPageOfScenes(),
              ),
            );
          },
          textStyle: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 23,
          ),
        ),
      ],
    );
  }

  void leftIconFunction(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopNavigationBar(
          'Scenes',
          FontAwesomeIcons.userCog,
          userCogFunction,
          leftIcon: FontAwesomeIcons.bars,
          leftIconFunction: leftIconFunction,
        ),
        Expanded(
          child: BlocProvider(
            create: (context) => getIt<ScenesInFoldersBloc>()
              ..add(const ScenesInFoldersEvent.initialized()),
            child: ScenesInFoldersL(),
          ),
        ),
      ],
    );
  }
}