import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../services/app_locales.dart';
import '../widgets/game_config_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primaryContainer.withAlpha(80),
      body: Column(
        children: [
          AppBar(
            title: Text(AppLocales.I('title')),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
            child: SvgPicture.asset(
              "assets/icons/icon.svg",
              color: scheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: GameConfigCard()),
              ),
            ),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, 'game'),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          AppLocales.I('start').toUpperCase(),
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }
}
