import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hexcolor/hexcolor_web.dart';
import 'package:redstone_daily_site/color_schemes.dart';
import 'package:redstone_daily_site/mainPage/date_text_widget.dart';
import 'package:redstone_daily_site/mainPage/parallelogram_button.dart';
import 'package:redstone_daily_site/painter/line_painter.dart';
import 'package:redstone_daily_site/painter/trapezoid_painter.dart';

import '../media_type.dart';
import '../contentPage/typography.dart';
import 'typography.dart';
import 'nav_bar.dart';
import 'nav_button.dart';

class MainContentPage2 extends StatelessWidget {
  const MainContentPage2({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var txtHeight = size.height;
    var textStyles = MainPageTypography(height: txtHeight);
    var width = size.width;
    var height = size.height;
    return Container(
      width: width,
      height: height,
      color: RDColorSchemes.white.background,
      child: Stack(children: [
        CustomPaint(
          painter: TrapezoidPainter(
            axis: Axis.horizontal,
            topEnd: 0.605,
            bottomEnd: 0.791,
            color: RDColorSchemes.scarlet.surface,
          ),
          size: Size(width, height),
        ),
        Positioned(
            top: height * 0.5,
            left: width * (0.605 + 0.791) / 2,
            child: FractionalTranslation(
                translation: const Offset(-0.31, -0.55),
                child: Transform.rotate(
                    angle: -18 * 3.14159 / 180,
                    child: SizedBox(
                      width: 0.562 * height,
                      height: 0.562 * height,
                      child: Image.asset("assets/images/knowledge_book.png"),
                    )))),
        Positioned(
            top: height * 0.085,
            right: width * 0.427,
            child: Text(
              "励志打造全国最大的",
              textAlign: TextAlign.end,
              style: textStyles.zhTextStyle1.copyWith(color: RDColorSchemes.scarlet.onSurface),
              maxLines: 1,
            )),
        Positioned(
            top: height * 0.266,
            right: width * 0.434,
            child: Text(
              "红石信息库",
              textAlign: TextAlign.end,
              style: textStyles.zhTextStyle1.copyWith(color: RDColorSchemes.scarlet.onSurface),
              maxLines: 1,
            )),
        Positioned(
            top: height * 0.577,
            left: width * 0.065,
            child: ParallelogramButton(
              width: 0.397 * width,
              height: 0.115 * height,
              text: "即刻搜索<<",
              textStyle: textStyles.zhTextStyle3.copyWith(color: RDColorSchemes.white.onBackground),
              buttonColor: RDColorSchemes.scarlet.onSurface,
              callback: () {
                print("clicked");
              },
            )),
        Positioned(
            top: height * 0.74,
            right: width * 0.3,
            child: Text(
              "通过每日的日报数据,长年累月即可形成\n庞大的数据库供查询。",
              textAlign: TextAlign.end,
              style: textStyles.zhTextStyle3.copyWith(color: RDColorSchemes.scarlet.onSurface),
              maxLines: 2,
            )),

        // Debug Reference Image
        // Positioned(
        //     top: 0,
        //     left: 0,
        //     child: Opacity(
        //         opacity: 0.3,
        //         child: Image.asset(
        //           "assets/test-ref-images/mainPage/2.png",
        //           width: size.width,
        //           fit: BoxFit.cover,
        //         )))
      ]),
    );
  }
}
