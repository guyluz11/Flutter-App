import 'package:cbj_integrations_controller/infrastructure/generic_devices/generic_printer_device/generic_printer_entity.dart';
import 'package:flutter/material.dart';

class ErrorPrintersDeviceCard extends StatelessWidget {
  const ErrorPrintersDeviceCard({
    required this.device,
    super.key,
  });

  final GenericPrinterDE? device;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.error,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Text(
              'Invalid device, please, contact support',
              style: Theme.of(context)
                  .primaryTextTheme
                  .bodyMedium!
                  .copyWith(fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              'Details for nerds:',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            Text(
              device!.failureOption.fold(() => '', (f) => f.toString()),
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}