part of 'package:cybearjinni/domain/device/i_device_repository.dart';

class _DeviceRepository implements IDeviceRepository {
  // final DeviceRemoteService _deviceRemoteService;
  // final DeviceLocalService _deviceLocalService;
  HashMap<String, DeviceEntityBase> allDevices =
      HashMap<String, DeviceEntityBase>();

  // @override
  // void addOrUpdateFromApp(dynamic entity) {
  //   if (entity is AreaEntity) {
  //     _addOrUpdateArea(entity);
  //   } else if (entity is DeviceEntityBase) {
  //     _addOrUpdateDevice(entity);
  //   } else {
  //     logger.w('Entity type to update ${entity.runtimeType} is not supported');
  //   }
  //   allResponseFromTheHubStreamController.sink
  //       .add(entity);
  // }

  @override
  void addOrUpdateDevice(DeviceEntityBase deviceEntity) {
    allDevices[deviceEntity.cbjDeviceVendor.getOrCrash()] = deviceEntity;
    devicesResponseFromTheHubStreamController.sink
        .add(allDevices.values.toImmutableList());
  }

  @override
  void addOrUpdateDeviceAndStateToWaiting(DeviceEntityBase deviceEntity) {
    addOrUpdateDevice(
      deviceEntity.copyWithDeviceState(
        EntityStateGRPC.waitingInComp,
      ),
    );
  }

  @override
  Future<void> initiateHubConnection() async {
    AppRequestsToHub.listenToApp();

    HubRequestRouting.navigateRequest();
  }

  @override
  Future<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      getAllEntites() async {
    try {
      return right(allDevices.values.toImmutableList());
    } catch (e) {
      if (e is PlatformException && e.message!.contains('PERMISSION_DENIED')) {
        logger.w('Insufficient permission while getting all devices');
        return left(const DevicesFailure.insufficientPermission());
      } else {
        logger.e('Unexpected error while getting all devices');
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
  }

  @override
  Stream<Either<dynamic, KtList>> watchAll() async* {
    yield* allResponseFromTheHubStreamController.map((event) => right(event));
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchAllDevices() async* {
    yield* devicesResponseFromTheHubStreamController.stream
        .map((event) => right(event));
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchLights() async* {
    // Using watchAll devices from server function and filtering out only the
    // Light device type
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                    EntityTypes.light.toString() ||
                element.entityTypes.getOrCrash() ==
                    EntityTypes.dimmableLight.toString() ||
                element.entityTypes.getOrCrash() ==
                    EntityTypes.rgbwLights.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchSwitches() async* {
    // Using watchAll devices from server function and filtering out only the
    // Switches device type
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.switch_.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchSmartPlugs() async* {
    // Using watchAll devices from server function and filtering out only the
    // Smart Plugs device type
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.smartPlug.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchSmartComputers() async* {
    // Using watchAll devices from server function and filtering out only the
    // Smart Computers device type
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.smartComputer.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchBlinds() async* {
    // Using watchAll devices from server function and filtering out only the
    // Blinds device type
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.blinds.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchBoilers() async* {
    // Using watchAll devices from server function and filtering out only the
    // Boilers device type
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.boiler.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchSmartTv() async* {
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.smartTV.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase?>>>
      watchPrinters() async* {
    yield* watchAllDevices().map(
      (event) => event.fold((l) => left(l), (r) {
        return right(
          r.toList().asList().where((element) {
            return element!.entityTypes.getOrCrash() ==
                EntityTypes.printer.toString();
          }).toImmutableList(),
        );
      }),
    );
  }

  @override
  Stream<Either<DevicesFailure, KtList<DeviceEntityBase>>> watchUncompleted() {
    // TODO: implement watchUncompleted
    throw UnimplementedError();
  }

  @override
  Future<Either<DevicesFailure, Unit>> create(
    DeviceEntityBase deviceEntity,
  ) async {
    try {
      String deviceModelString = 'No Model found';
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        logger.i(androidInfo.model);
        deviceModelString = androidInfo.model;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        logger.i(iosInfo.utsname.machine);
        deviceModelString = iosInfo.model;
      }

      const String currentUserId = 'user id';

      deviceEntity
          .copyWithStateMassage('Setting up device')
          .copyWithSenderDeviceOs(Platform.operatingSystem)
          .copyWithDeviceSenderDeviceModel(deviceModelString)
          .copyWithSenderId(currentUserId);

      DeviceEntityDtoBase.fromDomain();

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<DevicesFailure, Unit>> updateWithDeviceEntity({
    required DeviceEntityBase deviceEntity,
  }) async {
    return left(const DevicesFailure.unexpected());
  }

  @override
  Future<Either<DevicesFailure, Unit>> turnOnDevices({
    List<String>? devicesId,
    String? forceUpdateLocation,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericLightDE) {
          deviceEntity.lightSwitchState =
              GenericLightSwitchState(EntityActions.on.toString());
        } else if (deviceEntity is GenericDimmableLightDE) {
          deviceEntity.lightSwitchState =
              GenericDimmableLightSwitchState(EntityActions.on.toString());
        } else if (deviceEntity is GenericRgbwLightDE) {
          deviceEntity.lightSwitchState =
              GenericRgbwLightSwitchState(EntityActions.on.toString());
        } else if (deviceEntity is GenericSwitchDE) {
          deviceEntity.switchState =
              GenericSwitchSwitchState(EntityActions.on.toString());
        } else if (deviceEntity is GenericBoilerDE) {
          deviceEntity.boilerSwitchState =
              GenericBoilerSwitchState(EntityActions.on.toString());
        } else if (deviceEntity is GenericSmartPlugDE) {
          deviceEntity.smartPlugState =
              GenericSmartPlugState(EntityActions.on.toString());
        } else {
          logger.w(
            'On action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> turnOffDevices({
    List<String>? devicesId,
    String? forceUpdateLocation,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericLightDE) {
          deviceEntity.lightSwitchState =
              GenericLightSwitchState(EntityActions.off.toString());
        } else if (deviceEntity is GenericDimmableLightDE) {
          deviceEntity.lightSwitchState =
              GenericDimmableLightSwitchState(EntityActions.off.toString());
        } else if (deviceEntity is GenericRgbwLightDE) {
          deviceEntity.lightSwitchState =
              GenericRgbwLightSwitchState(EntityActions.off.toString());
        } else if (deviceEntity is GenericSwitchDE) {
          deviceEntity.switchState =
              GenericSwitchSwitchState(EntityActions.off.toString());
        } else if (deviceEntity is GenericBoilerDE) {
          deviceEntity.boilerSwitchState =
              GenericBoilerSwitchState(EntityActions.off.toString());
        } else if (deviceEntity is GenericSmartPlugDE) {
          deviceEntity.smartPlugState =
              GenericSmartPlugState(EntityActions.off.toString());
        } else {
          logger.w(
            'Off action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> changeColorTemperatureDevices({
    required List<String>? devicesId,
    required int colorTemperatureToChange,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericRgbwLightDE) {
          deviceEntity.lightColorTemperature = GenericRgbwLightColorTemperature(
            colorTemperatureToChange.toString(),
          );
        } else {
          logger.w(
            'Off action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        try {
          if (!deviceEntity.doesWaitingToSendTemperatureColorRequest) {
            deviceEntity.doesWaitingToSendTemperatureColorRequest = true;

            final Future<Either<DevicesFailure, Unit>> updateEntityResponse =
                updateWithDeviceEntity(deviceEntity: deviceEntity);

            await Future.delayed(
              Duration(
                milliseconds:
                    deviceEntity.sendNewTemperatureColorEachMilliseconds,
              ),
            );
            deviceEntity.doesWaitingToSendTemperatureColorRequest = false;

            return updateEntityResponse;
          }
        } catch (e) {
          await Future.delayed(
            Duration(
              milliseconds:
                  deviceEntity.sendNewTemperatureColorEachMilliseconds,
            ),
          );
          deviceEntity.doesWaitingToSendTemperatureColorRequest = false;
          return left(const DevicesFailure.unexpected());
        }
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> changeHsvColorDevices({
    required List<String>? devicesId,
    required HSVColor hsvColorToChange,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericRgbwLightDE) {
          deviceEntity
            ..lightColorAlpha =
                GenericRgbwLightColorAlpha(hsvColorToChange.alpha.toString())
            ..lightColorHue =
                GenericRgbwLightColorHue(hsvColorToChange.hue.toString())
            ..lightColorSaturation = GenericRgbwLightColorSaturation(
              hsvColorToChange.saturation.toString(),
            )
            ..lightColorValue =
                GenericRgbwLightColorValue(hsvColorToChange.value.toString());
        } else {
          logger.w(
            'Off action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        try {
          if (!deviceEntity.doesWaitingToSendHsvColorRequest) {
            deviceEntity.doesWaitingToSendHsvColorRequest = true;

            final Future<Either<DevicesFailure, Unit>> updateEntityResponse =
                updateWithDeviceEntity(deviceEntity: deviceEntity);

            await Future.delayed(
              Duration(
                milliseconds: deviceEntity.sendNewHsvColorEachMilliseconds,
              ),
            );
            deviceEntity.doesWaitingToSendHsvColorRequest = false;

            return updateEntityResponse;
          }
        } catch (e) {
          await Future.delayed(
            Duration(
              milliseconds: deviceEntity.sendNewHsvColorEachMilliseconds,
            ),
          );
          deviceEntity.doesWaitingToSendHsvColorRequest = false;
          return left(const DevicesFailure.unexpected());
        }
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> changeBrightnessDevices({
    required List<String>? devicesId,
    required int brightnessToChange,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);
    Either<DevicesFailure, Unit> totalActionResult = right(unit);

    try {
      Either<DevicesFailure, Unit> actionResult;

      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        } else if (deviceEntity is GenericDimmableLightDE) {
          deviceEntity.lightBrightness =
              GenericDimmableLightBrightness(brightnessToChange.toString());
          actionResult = await dimDimmableLight(deviceEntity);
        } else if (deviceEntity is GenericRgbwLightDE) {
          deviceEntity.lightBrightness =
              GenericRgbwLightBrightness(brightnessToChange.toString());
          actionResult = await dimRgbwLight(deviceEntity);
        } else {
          logger.w(
            'Brightness action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }
        if (actionResult.isLeft()) {
          totalActionResult = actionResult;
        }
      }
      return totalActionResult;
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
  }

  Future<Either<DevicesFailure, Unit>> dimDimmableLight(
    GenericDimmableLightDE deviceEntity,
  ) async {
    try {
      if (!deviceEntity.doesWaitingToSendBrightnessRequest) {
        deviceEntity.doesWaitingToSendBrightnessRequest = true;

        final Future<Either<DevicesFailure, Unit>> updateEntityResponse =
            updateWithDeviceEntity(deviceEntity: deviceEntity);

        await Future.delayed(
          Duration(
            milliseconds: deviceEntity.sendNewBrightnessEachMilliseconds,
          ),
        );
        deviceEntity.doesWaitingToSendBrightnessRequest = false;
        return updateEntityResponse;
      }
    } catch (e) {
      await Future.delayed(
        Duration(
          milliseconds: deviceEntity.sendNewBrightnessEachMilliseconds,
        ),
      );
      deviceEntity.doesWaitingToSendBrightnessRequest = false;
      return left(const DevicesFailure.unexpected());
    }
    return right(unit);
  }

  Future<Either<DevicesFailure, Unit>> dimRgbwLight(
    GenericRgbwLightDE deviceEntity,
  ) async {
    try {
      if (!deviceEntity.doesWaitingToSendBrightnessRequest) {
        deviceEntity.doesWaitingToSendBrightnessRequest = true;

        final Future<Either<DevicesFailure, Unit>> updateEntityResponse =
            updateWithDeviceEntity(deviceEntity: deviceEntity);

        await Future.delayed(
          Duration(
            milliseconds: deviceEntity.sendNewBrightnessEachMilliseconds,
          ),
        );
        deviceEntity.doesWaitingToSendBrightnessRequest = false;
        return updateEntityResponse;
      }
    } catch (e) {
      await Future.delayed(
        Duration(
          milliseconds: deviceEntity.sendNewBrightnessEachMilliseconds,
        ),
      );
      deviceEntity.doesWaitingToSendBrightnessRequest = false;
      return left(const DevicesFailure.unexpected());
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> moveUpStateDevices({
    List<String>? devicesId,
    String? forceUpdateLocation,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericBlindsDE) {
          deviceEntity.blindsSwitchState =
              GenericBlindsSwitchState(EntityActions.moveUp.toString());
        } else {
          logger.w(
            'Off action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> stopStateDevices({
    List<String>? devicesId,
    String? forceUpdateLocation,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericBlindsDE) {
          deviceEntity.blindsSwitchState =
              GenericBlindsSwitchState(EntityActions.stop.toString());
        } else if (deviceEntity is GenericSmartTvDE) {
          deviceEntity.pausePlayState = GenericSmartTvPausePlayState(
            EntityActions.stop.toString(),
          );
        } else {
          logger.w(
            'Stop action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> moveDownStateDevices({
    List<String>? devicesId,
    String? forceUpdateLocation,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericBlindsDE) {
          deviceEntity.blindsSwitchState =
              GenericBlindsSwitchState(EntityActions.moveDown.toString());
        } else {
          logger.w(
            'Move down action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> suspendDevices({
    required List<String>? devicesId,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericSmartComputerDE) {
          deviceEntity.smartComputerSuspendState =
              GenericSmartComputerSuspendState(
            EntityActions.suspend.toString(),
          );
        } else {
          logger.w(
            'Suspend action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> shutdownDevices({
    required List<String>? devicesId,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericSmartComputerDE) {
          deviceEntity.smartComputerShutDownState =
              GenericSmartComputerShutdownState(
            EntityActions.shutdown.toString(),
          );
        } else {
          logger.w(
            'Shutdown action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> changeVolumeDevices({
    required List<String>? devicesId,
  }) async {
    // TODO: implement changeVolumeDevices
    throw UnimplementedError();
  }

  @override
  Future<Either<DevicesFailure, Unit>> closeStateDevices({
    List<String>? devicesId,
    String? forceUpdateLocation,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericBlindsDE) {
          deviceEntity.blindsSwitchState =
              GenericBlindsSwitchState(EntityActions.close.toString());
        } else {
          logger.w(
            'Close action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> pauseStateDevices({
    required List<String>? devicesId,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericSmartTvDE) {
          deviceEntity.pausePlayState = GenericSmartTvPausePlayState(
            EntityActions.pause.toString(),
          );
        } else {
          logger.w(
            'Pause action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> playStateDevices({
    required List<String>? devicesId,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericSmartTvDE) {
          deviceEntity.pausePlayState = GenericSmartTvPausePlayState(
            EntityActions.play.toString(),
          );
        } else {
          logger.w(
            'Play action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> queuePrevStateDevices({
    required List<String>? devicesId,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericSmartTvDE) {
          deviceEntity.pausePlayState = GenericSmartTvPausePlayState(
            EntityActions.skipPreviousVid.toString(),
          );
        } else {
          logger.w(
            'Skip prev vid action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  @override
  Future<Either<DevicesFailure, Unit>> queueNextStateDevices({
    required List<String>? devicesId,
  }) async {
    final List<DeviceEntityBase?> deviceEntityListToUpdate =
        await getDeviceEntityListFromId(devicesId!);

    try {
      for (final DeviceEntityBase? deviceEntity in deviceEntityListToUpdate) {
        if (deviceEntity == null) {
          continue;
        }
        if (deviceEntity is GenericSmartTvDE) {
          deviceEntity.pausePlayState = GenericSmartTvPausePlayState(
            EntityActions.skipNextVid.toString(),
          );
        } else {
          logger.w(
            'Skip next vid action not supported for'
            ' ${deviceEntity.entityTypes.getOrCrash()} type',
          );
          continue;
        }

        updateWithDeviceEntity(deviceEntity: deviceEntity);
      }
    } on PlatformException catch (e) {
      if (e.message!.contains('PERMISSION_DENIED')) {
        return left(const DevicesFailure.insufficientPermission());
      } else if (e.message!.contains('NOT_FOUND')) {
        return left(const DevicesFailure.unableToUpdate());
      } else {
        // log.error(e.toString());
        return left(const DevicesFailure.unexpected());
      }
    }
    return right(unit);
  }

  Future<Either<DevicesFailure, Unit>> updateComputer(
    DeviceEntityBase deviceEntity,
  ) async {
    try {
      addOrUpdateDeviceAndStateToWaiting(deviceEntity);

      try {
        deviceEntity.copyWithDeviceState(EntityStateGRPC.waitingInCloud);

        final String deviceDtoAsString =
            DeviceHelper.convertDomainToJsonString(deviceEntity);
        final ClientStatusRequests clientStatusRequests = ClientStatusRequests(
          allRemoteCommands: deviceDtoAsString,
          sendingType: SendingType.entityType,
        );
        AppRequestsToHub.appRequestsToHubStreamController
            .add(clientStatusRequests);
      } catch (e) {
        logger.e('This is the error\n$e');

        // final DocumentReference homeDoc =
        //     await _firestore.currentHomeDocument();
        // final CollectionReference devicesCollection =
        //     homeDoc.devicesCollecttion;
        // final DocumentReference deviceDocumentReference =
        //     devicesCollection.doc(deviceEntity.id!.getOrCrash());
        // updateDatabase(documentPath: deviceDocumentReference, fieldsToUpdate: {
        //   'lastKnownIp': lastKnownIp,
        // });
      }

      return right(unit);
    } catch (e) {
      logger.w('Probably ip of device was not inserted into the device object');
      return left(const DevicesFailure.unexpected());
    }
  }

  Future<List<DeviceEntityBase?>> getDeviceEntityListFromId(
    List<String> deviceIdList,
  ) async {
    final List<DeviceEntityBase> deviceEntityList = [];

    if (allDevices.isEmpty) {
      return [];
    }

    for (final deviceId in deviceIdList) {
      final DeviceEntityBase? device = allDevices[deviceId];
      if (device == null) {
        continue;
      }
      deviceEntityList.add(device);
    }
    return deviceEntityList;
  }

  /// Search device IP by computer Avahi (mdns) name
  Future<String> getDeviceIpByDeviceAvahiName(String mDnsName) async {
    String deviceIp = '';
    final String fullMdnsName = '$mDnsName.local';

    final MDnsClient client = MDnsClient(
      rawDatagramSocketFactory: (
        dynamic host,
        int port, {
        bool? reuseAddress,
        bool? reusePort,
        int? ttl,
      }) {
        return RawDatagramSocket.bind(host, port, ttl: ttl!);
      },
    );
    // Start the client with default options.

    await client.start();
    await for (final IPAddressResourceRecord record
        in client.lookup<IPAddressResourceRecord>(
      ResourceRecordQuery.addressIPv4(fullMdnsName),
    )) {
      deviceIp = record.address.address;
      logger.t('Found address (${record.address}).');
    }

    // await for (final IPAddressResourceRecord record
    //     in client.lookup<IPAddressResourceRecord>(
    //         ResourceRecordQuery.addressIPv6(fullMdnsName))) {
    //   logger.t('Found address (${record.address}).');
    // }

    client.stop();

    logger.t('Done.');

    return deviceIp;
  }

  /// How to send the data, in the local network or the remote server/cloud
  Future<String> whereToUpdateDevicesData(
    String? forceUpdateLocation,
    String? deviceSecondWifiName,
  ) async {
    String updateLocation;

    try {
      if (forceUpdateLocation == null) {
        final status = await Permission.location.status;
        if (status.isDenied) {
          Permission.location.request();
        }

        final String? wifiName = await NetworkInfo().getWifiName();

        if (deviceSecondWifiName != null &&
            deviceSecondWifiName.isNotEmpty &&
            deviceSecondWifiName == wifiName) {
          updateLocation = 'L'; // L for local network
        } else {
          updateLocation = 'R'; // R for remote
        }
      } else {
        updateLocation = forceUpdateLocation;
      }
    } catch (exception) {
      updateLocation = 'L';
    }

    return updateLocation;
  }

  /// Stream controller of the app request for the hub
  @override
  BehaviorSubject<KtList> allResponseFromTheHubStreamController =
      BehaviorSubject<KtList>();

  @override
  BehaviorSubject<KtList<DeviceEntityBase>>
      devicesResponseFromTheHubStreamController =
      BehaviorSubject<KtList<DeviceEntityBase>>();

  @override
  BehaviorSubject<KtList<AreaEntity>> areasResponseFromTheHubStreamController =
      BehaviorSubject<KtList<AreaEntity>>();
}
