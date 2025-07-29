import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20),
              child: AspectRatio(
                aspectRatio: 1,
                child: SvgPicture.asset(
                  "assets/icons/Logotype.png",
                  color: scheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(2 + 5.w),
              child: Center(child: GameConfigCard()),
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
        padding: EdgeInsets.all(5 + 1.h),
        child: Text(
          AppLocales.I('start').toUpperCase(),
          style: TextStyle(fontSize: 12 + 8.sp),
        ),
      ),
    );
  }
}
