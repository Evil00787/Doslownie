import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../services/app_locales.dart';
import '../widgets/custom_app_bar.dart';
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
          CustomAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: GameConfigCard()),
                  ),
                ),
              ),
            ),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, 'game'),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            AppLocales.I('start').toUpperCase(),
            style: TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }
}
