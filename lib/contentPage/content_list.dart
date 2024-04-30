import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:redstone_daily_site/color_schemes.dart';
import 'package:redstone_daily_site/contentPage/content_widget.dart';
import 'package:redstone_daily_site/jsonobject/NewsPaper.dart';
import 'package:redstone_daily_site/media_type.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:http/http.dart' as http;

double lerp(double a, double b, double t) {
  return a + (b - a) * t;
}

double inverseLerp(double a, double b, double x) {
  return (x - a) / (b - a);
}

// 网站内容列表
class ContentList extends StatefulWidget {
  const ContentList({super.key, required this.year, required this.month, required this.day});
  final String year;
  final String month;
  final String day;

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  static const double listPaddingMedium = 280;
  static const double listPaddingSmall = 0;
  static const double listInnerPadding = 20;

  // for large device, it is free
  static const double itemPadding = 20;

  late Future<NewsPaper> _futureBuildItems;

  // 异步获取json字符串
  Future<String> fetchJson(BuildContext context) async {
    // return DefaultAssetBundle.of(context).loadString("assets/demo.json");
    // fetch data from url api
    const String apiHost = String.fromEnvironment('API_BASE_URL', defaultValue: 'localhost');
    Uri uri = Uri.http(apiHost, '/daily', {
      'yy': widget.year,
      'mm': widget.month,
      'dd': widget.day,
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // 如果请求成功，返回JSON字符串
        return response.body;
      } else {
        // 如果请求失败，抛出一个错误
        throw Exception('Failed to load JSON. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // 处理任何其他类型的错误
      print('Error occurred: $error');
      rethrow; // 你可以选择在这里重新抛出错误或返回一个错误消息
    }
  }

  @override
  void initState() {
    super.initState();
    // 获取内容信息json，并构建内容组件列表
    _futureBuildItems = fetchJson(context).then((str) => newsPaperFromJson(str));
  }

  @override
  Widget build(BuildContext context) {
    builder(BuildContext context, AsyncSnapshot<NewsPaper> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // 当Future还未完成时，显示加载中的UI
        return SliverFillRemaining(
            child: Container(
          color: RDColors.white.surface,
          child: const Center(child: CircularProgressIndicator()),
        ));
      } else if (snapshot.hasError) {
        // 当Future发生错误时，显示错误提示的UI
        return Text('Error: ${snapshot.error}');
      } else {
        // 当Future成功完成时，显示数据
        return buildWithNewsPaper(snapshot.data!, context);
      }
    }

    return FutureBuilder(
      future: _futureBuildItems,
      builder: builder,
    );
  }

  List<ContentWidget> buildItemWidgets(NewsPaper paper) {
    List<ContentWidget> items = [];
    paper.content.asMap().entries.forEach((entry) {
      var index = entry.key;
      var content = entry.value;
      items.add(ContentWidget(
        url: content.url,
        imageUrl: content.coverUrl,
        title: content.title,
        description: content.description,
        ranking: index + 1,
      ));
    });
    return items;
  }

  // 根据NewsPaper结构进行页面的构建
  Widget buildWithNewsPaper(NewsPaper paper, BuildContext context) {
    var mediaType = getMediaType(context);
    var size = MediaQuery.of(context).size;
    var itemScaling = min(1.0, size.width / MediaType.medium.width);

    var items = buildItemWidgets(paper);

    var commonItems = <ContentWidget>[];
    commonItems.addAll(items);
    commonItems.removeRange(0, 3);

    var maxWidth = MediaType.large.width - 2 * listPaddingMedium;

    return SliverPadding(
        // 设置两边平行同步
        padding: EdgeInsets.symmetric(
          horizontal: switch (mediaType) {
            MediaType.small => listPaddingSmall,
            MediaType.medium => lerp(listPaddingSmall, listPaddingMedium, inverseLerp(MediaType.medium.width, MediaType.large.width, size.width)),
            MediaType.large => (size.width - maxWidth) / 2,
          },
        ),
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: RDColors.white.surface,
          ),
          sliver: SliverPadding(
            padding: EdgeInsets.fromLTRB(listInnerPadding, itemPadding * itemScaling, listInnerPadding, 0),
            sliver: MultiSliver(
              children: [
                SliverPadding(
                    padding: EdgeInsets.only(bottom: 25 * itemScaling),
                    sliver: SliverToBoxAdapter(
                        child: SizedBox(
                      height: ContentWidget.maxHeightHeader * itemScaling,
                      child: items[0],
                    ))),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: itemPadding * itemScaling),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mediaType == MediaType.small ? 1 : 2,
                      mainAxisExtent: (mediaType == MediaType.small ? 1.5 : 1) * ContentWidget.maxHeightSubHeader * itemScaling,
                      crossAxisSpacing: itemPadding * itemScaling,
                      mainAxisSpacing: itemPadding * itemScaling,
                    ),
                    delegate: SliverChildListDelegate([items[1], items[2]]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 30),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mediaType == MediaType.small ? 1 : 2,
                      mainAxisExtent: (mediaType == MediaType.small ? 1.5 : 1) * ContentWidget.maxHeightContent * itemScaling,
                      crossAxisSpacing: itemPadding * itemScaling,
                      mainAxisSpacing: itemPadding * itemScaling,
                    ),
                    delegate: SliverChildListDelegate(commonItems),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}