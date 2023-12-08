import 'package:auto_route/auto_route.dart';
import 'package:cbj_integrations_controller/domain/room/room_entity.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_devices/generic_smart_plug_device/generic_smart_plug_entity.dart';
import 'package:cybear_jinni/infrastructure/core/logger.dart';
import 'package:cybear_jinni/presentation/atoms/atoms.dart';
import 'package:cybear_jinni/presentation/pages/shared_widgets/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

@RoutePage()
class SettingsPageOfSmartPlugsPage extends StatelessWidget {
  SettingsPageOfSmartPlugsPage({required this.roomEntity}) {
    // for (final SmartRoomObject smartRoomObject in rooms) {
    //   for (final SmartDeviceObject smartSmartPlugObject
    //       in smartRoomObject.getSmartPlugs()) {
    //     allSmartDeviceSmartPlugDevices.add(smartSmartPlugObject);
    //   }
    // }
  }

  final RoomEntity roomEntity;
  final List<GenericSmartPlugDE> allSmartDeviceSmartPlugDevices =
      <GenericSmartPlugDE>[];

  @override
  Widget build(BuildContext context) {
    Widget tile(String roomName, String smartPlugName) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Icon(MdiIcons.powerSocketAu),
            ),
            title: TextAtom(
              'Name:_',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              translationArgs: [smartPlugName],
            ),
            subtitle: TextAtom(
              'Room:_',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              translationArgs: [roomName],
            ),
            trailing: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.pen,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              onPressed: () {},
            ),
          ),
          Divider(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ],
      );
    }

    void backButtonFunction(BuildContext context) {
      context.router.pop();
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //  FontAwesomeIcons.plus,
        onPressed: () async {},
        child: const FaIcon(Icons.add),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: const <double>[0, 0, 0, 1],
            colors: <Color>[
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            TopNavigationBar(
              pageName: 'SmartPlugs Settings',
              rightIcon: null,
              leftIcon: FontAwesomeIcons.arrowLeft,
              leftIconFunction: backButtonFunction,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(index.toString()),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        logger.w('Delete the card');
                      }
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: tile(
                      roomEntity.cbjEntityName.getOrCrash(),
                      allSmartDeviceSmartPlugDevices[index]
                          .cbjEntityName
                          .getOrCrash()!,
                    ),
                  );
                },
                itemCount: allSmartDeviceSmartPlugDevices.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}