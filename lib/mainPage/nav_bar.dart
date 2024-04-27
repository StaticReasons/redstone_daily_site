import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../media_type.dart';
import 'nav_underlined_text.dart';
import 'nav_button.dart';

class NavBar extends StatelessWidget {
  ///
  /// 布局行为：
  /// 宽度会拉伸至最大宽度 --- 即宽度等于maxWidth约束；
  /// 高度会收缩至文字排版所需的最多高度，除非受父级限制 --- 即高度等于内部最大高度与minHeight约束的最大值。
  /// - 以上行为定义其实等效于Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center)
  /// - 原则上内部文字所需的高度是不可预测的，即使它是由textStyle.fontSize等决定的。
  ///   因此在没有约束最小高度的条件下整个导航栏的高度，包围着各文字的高度，也是不可预测的。
  ///   所以请酌情设定保留一个足够的高度（）
  const NavBar({
    super.key,
    required this.style,
  });

  final TextStyle style;
  static const flexPadding = 1;
  static const flexNavItem = 3;
  static const flexSearchBarMargin = 2;
  static const flexSearchBar = 10;

  @override
  Widget build(BuildContext context) {

    Widget navItem({required String dst, required String text, bool isRoute = true}) {
      return Flexible(
        flex: flexNavItem,
        fit: FlexFit.tight,
        child: NavUnderlinedText(
          dst: dst,
          text: text,
          isRoute: isRoute,
          style: style,
          underlineColor: Colors.white,
          underlineWidth: 1.5,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: flexPadding),
        Text(" / ", style: style),
        navItem(dst: "/daily", text: "日报"),
        Text(" / ", style: style),
        navItem(dst: "/404", text: "探索"),
        Text(" / ", style: style),
        navItem(dst: "/404", text: "更多"),
        Text(" / ", style: style),
        const Spacer(flex: flexSearchBarMargin),
        Flexible(flex: flexSearchBar, child: searchBar()),
        const Spacer(flex: flexSearchBarMargin),
        Text(" / ", style: style),
        navItem(dst: "/404", text: "赞助"),
        Text(" / ", style: style),
        navItem(dst: "/404", text: "源码"),
        Text(" / ", style: style),
        navItem(dst: "/404", text: "贡献"),
        Text(" / ", style: style),
        const Spacer(flex: flexPadding),
      ],
    );
  }

  Widget searchBar() {
    return TextField(
              textAlign: TextAlign.center,
              style: style,
              decoration: InputDecoration(
                hintText: "搜索日报内容",
                hintStyle: style,
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                enabledBorder: const UnderlineInputBorder(
                  // 不是焦点的时候颜色
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  // 焦点集中的时候颜色
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            );
  }
}
