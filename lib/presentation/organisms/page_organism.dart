import 'package:auto_route/auto_route.dart';
import 'package:cybearjinni/presentation/molecules/top_bar_molecule.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PageOrganism extends StatelessWidget {
  const PageOrganism({
    required this.child,
    required this.pageName,
    this.topBarColor,
  });

  final Widget child;
  final String pageName;
  final Color? topBarColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: TopBarMolecule(
              pageName: pageName,
              backgroundColor: topBarColor,
              leftIcon: FontAwesomeIcons.arrowLeft,
              leftIconFunction: (_) => context.router.pop(),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
