import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:footballer/constants.dart';
import 'package:footballer/models/league.dart';

import '../../../languages.dart';

class HomeTop extends StatelessWidget {
  final double height;
  final Function onViewAllTap;
  final ValueSetter<League> onLeagueTap;
  const HomeTop({Key key, this.height, this.onViewAllTap, this.onLeagueTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _leagues = League.leagues;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(marginLarge),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(AppLocale.fixtures.getString(context),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeLarge,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onViewAllTap,
                  child: Visibility(
                    visible: onViewAllTap != null,
                    child: Text(AppLocale.viewAll.getString(context),
                      style: TextStyle(
                          color: Colors.black, fontSize: fontSizeStandard),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _leagues.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      onLeagueTap(_leagues[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: marginLarge,
                      ),
                      width: 75,
                      height: 75,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(_leagues[index].logo),
                      ),
                    ),
                    // child: Container(
                    //   margin: const EdgeInsets.symmetric(
                    //     horizontal: marginLarge,
                    //   ),
                    //   width: 55,
                    //   height: 55,
                    //   child: Image.asset(_leagues[index].logo),
                    // ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
