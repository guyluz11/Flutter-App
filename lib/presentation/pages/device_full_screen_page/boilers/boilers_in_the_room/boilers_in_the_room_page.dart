import 'package:cbj_integrations_controller/domain/room/smart_room_object.dart';
import 'package:cybear_jinni/presentation/core/theme_data.dart';
import 'package:cybear_jinni/presentation/pages/device_full_screen_page/boilers/widgets/room_boilers_toggles_block.dart';
import 'package:cybear_jinni/presentation/pages/shared_widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Page to show all the boilers in selected room
class BoilersInTheRoomPage extends StatelessWidget {
  BoilersInTheRoomPage({required this.thisSmartRoom});

  final SmartRoomObject? thisSmartRoom;
  final List<Map<String, dynamic>> productsInThisRoom =
      <Map<String, dynamic>>[];

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
          gradient: BacgroundGradient.getBacground(context),
        ),
        child: Column(
          children: <Widget>[
            TopNavigationBar(
              pageName: thisSmartRoom!.getRoomName(),
              rightIcon: Icons.more_vert,
              rightIconFunction: () {},
              leftIcon: FontAwesomeIcons.arrowLeft,
              leftIconFunction: backButtonFunction,
              rightSecondIcon: FontAwesomeIcons.magnifyingGlass,
              rightSecondFunction: () {},
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: SingleChildScrollView(
                  child: RoomBoilersTogglesBlock(thisSmartRoom),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}