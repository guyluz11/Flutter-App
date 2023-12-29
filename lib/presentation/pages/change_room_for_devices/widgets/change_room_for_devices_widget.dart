import 'package:auto_route/auto_route.dart';
import 'package:cbj_integrations_controller/domain/room/i_room_repository.dart';
import 'package:cbj_integrations_controller/domain/room/room_entity.dart';
import 'package:cbj_integrations_controller/domain/room/value_objects_room.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_entities/abstract_entity/device_entity_base.dart';
import 'package:cybearjinni/domain/device/i_device_repository.dart';
import 'package:cybearjinni/presentation/atoms/atoms.dart';
import 'package:cybearjinni/presentation/core/routes/app_router.gr.dart';
import 'package:cybearjinni/presentation/core/snack_bar_service.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ChangeRoomForDevicesWidget extends StatefulWidget {
  @override
  State<ChangeRoomForDevicesWidget> createState() =>
      _ChangeRoomForDevicesWidgetState();
}

class _ChangeRoomForDevicesWidgetState
    extends State<ChangeRoomForDevicesWidget> {
  Set<RoomEntity?> _allRooms = {};
  Set<DeviceEntityBase?> _allDevices = {};
  RoomUniqueId roomUniqueId = RoomUniqueId();
  RoomDefaultName cbjEntityName = RoomDefaultName('');
  RoomBackground background = RoomBackground(
    'https://live.staticflickr.com/5220/5486044345_f67abff3e9_h.jpg',
  );
  RoomTypes roomTypes = RoomTypes(const {});
  RoomDevicesId roomDevicesId = RoomDevicesId(const {});
  RoomScenesId roomScenesId = RoomScenesId(const {});
  RoomRoutinesId roomRoutinesId = RoomRoutinesId(const {});
  RoomBindingsId roomBindingsId = RoomBindingsId(const {});
  RoomMostUsedBy roomMostUsedBy = RoomMostUsedBy(const {});
  RoomPermissions roomPermissions = RoomPermissions(const {});
  bool showErrorMessages = false;
  bool isSubmitting = false;
  dartz.Option authFailureOrSuccessOption = dartz.none();

  @override
  void initState() {
    super.initState();
    _initialized();
  }

  Future<void> _initialized() async {
    IRoomRepository.instance.getAllRooms().fold((l) => null, (r) {
      _allRooms = Set<RoomEntity>.from(r.iter);
    });

    (await IDeviceRepository.instance.getAllEntites()).fold((l) => null, (r) {
      _allDevices = Set<DeviceEntityBase>.from(r.iter);
    });
    _allRooms.removeWhere((element) => element == null);
    _allDevices.removeWhere((element) => element == null);
    setState(() {
      _allRooms = _allRooms as Set<RoomEntity>;
      _allDevices = _allDevices as Set<DeviceEntityBase>;
    });
  }

  Future<void> _changeRoomDevices() async {
    final RoomEntity roomEntity = RoomEntity(
      uniqueId: RoomUniqueId.fromUniqueString(roomUniqueId.getOrCrash()),
      cbjEntityName: RoomDefaultName(cbjEntityName.getOrCrash()),
      background: RoomBackground(background.getOrCrash()),
      roomTypes: RoomTypes(roomTypes.getOrCrash()),
      roomDevicesId: RoomDevicesId(roomDevicesId.getOrCrash()),
      roomScenesId: RoomScenesId(roomScenesId.getOrCrash()),
      roomRoutinesId: RoomRoutinesId(roomRoutinesId.getOrCrash()),
      roomBindingsId: RoomBindingsId(roomBindingsId.getOrCrash()),
      roomMostUsedBy: RoomMostUsedBy(roomMostUsedBy.getOrCrash()),
      roomPermissions: RoomPermissions(roomPermissions.getOrCrash()),
    );

    IRoomRepository.instance.create(roomEntity);
  }

  Future<void> _roomIdChanged(String value) async {
    for (final RoomEntity? roomEntity in _allRooms) {
      if (roomEntity != null && roomEntity.uniqueId.getOrCrash() == value) {
        setState(() {
          roomUniqueId = roomEntity.uniqueId;
          cbjEntityName = roomEntity.cbjEntityName;
          authFailureOrSuccessOption = dartz.none();
        });

        return;
      }
    }
  }

  Future<void> _roomDevicesIdChanged(Set<String> value) async {
    setState(() {
      roomDevicesId = RoomDevicesId(value);
      authFailureOrSuccessOption = dartz.none();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: screenSize.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextAtom(
                'Choose Area',
                style: TextStyle(fontSize: 27),
              ),
              TextButton(
                onPressed: () {
                  context.router.push(const AddNewRoomRoute());
                },
                child: const TextAtom(
                  'Add New Area',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            icon: const Icon(Icons.arrow_drop_down),
            hint: TextAtom(
              cbjEntityName.isValid()
                  ? cbjEntityName.getOrCrash()
                  : 'Choose Area',
            ),
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (value) {
              _roomIdChanged(value!);
            },
            items: _allRooms.map<DropdownMenuItem<String>>((e) {
              //     .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: e?.uniqueId.getOrCrash(),
                child: TextAtom(e?.cbjEntityName.getOrCrash() ?? ''),
              );
            }).toList(),
          ),
          SizedBox(
            height: screenSize.height * 0.1,
          ),
          const Row(
            children: [
              TextAtom(
                'Choose Device',
                style: TextStyle(fontSize: 27),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(maxHeight: screenSize.height * 0.5),
            child: SingleChildScrollView(
              child: MultiSelectDialogField(
                items: List<MultiSelectItem<String?>>.of(
                  _allDevices.map(
                    (e) => MultiSelectItem(
                      e?.uniqueId.getOrCrash(),
                      e?.cbjEntityName.getOrCrash()! ?? '',
                    ),
                  ),
                ),
                listType: MultiSelectListType.CHIP,
                onConfirm: (List<String?> values) {
                  _roomDevicesIdChanged(
                    Set<String>.from(values),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  SnackBarService().show(
                    context,
                    'Changing devices for area',
                  );
                  _changeRoomDevices();
                },
                child: const TextAtom(
                  'Done',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
