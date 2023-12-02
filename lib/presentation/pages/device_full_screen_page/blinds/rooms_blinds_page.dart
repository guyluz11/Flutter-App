import 'package:auto_route/auto_route.dart';
import 'package:cbj_integrations_controller/domain/room/room_entity.dart';
import 'package:cybear_jinni/presentation/core/theme_data.dart';
import 'package:cybear_jinni/presentation/pages/device_full_screen_page/blinds/settings_page_of_blinds.dart';
import 'package:cybear_jinni/presentation/pages/device_full_screen_page/blinds/widgets/rooms_blinds_widget.dart';
import 'package:cybear_jinni/presentation/pages/shared_widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Blinds page that will call the blind widgets file and add background
/// and scaffold for it
@RoutePage()
class RoomsBlindsPage extends StatelessWidget {
  const RoomsBlindsPage({
    required this.roomEntity,
    this.roomColorGradiant,
  });

  final RoomEntity roomEntity;
  final ListOfColors? roomColorGradiant;

  void cogFunction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsPageOfBlinds(
          roomEntity: roomEntity,
        ),
      ),
    );
  }

  void backButtonFunction(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: BackgroundGradient.getBackground(context),
        ),
        child: Column(
          children: [
            TopNavigationBar(
              pageName: 'Blinds',
              rightIcon: null,
              rightIconFunction: cogFunction,
              leftIcon: FontAwesomeIcons.arrowLeft,
              leftIconFunction: backButtonFunction,
              backgroundColor: roomColorGradiant!.listOfColors!.last,
            ),
            Expanded(
              child: RoomsBlindsWidget(
                roomEntity: roomEntity,
                roomColorGradiant: roomColorGradiant!.listOfColors!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
