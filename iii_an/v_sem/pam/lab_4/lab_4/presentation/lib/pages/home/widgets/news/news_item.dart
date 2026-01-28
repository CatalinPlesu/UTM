import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/models/article.dart';
import 'package:domain/models/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lab_4/pages/article/article_controller.dart';
import 'package:lab_4/pages/home/home_controller.dart';
import 'package:lab_4/resources/custom_collors.dart';
import 'package:lab_4/resources/svg_assets.dart';
import 'package:lab_4/resources/text_styles.dart';

class NewsItem extends StatelessWidget {
  final Article article;
  NewsItem({super.key, required this.article});
  HomeController controller = Get.find();
  ArticleController articleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        controller.openArticle(article);
      },
      child: Container(
        // color: Colors.pink,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: CustomColors.athensGray,
              width: 1.0,
              style: BorderStyle.solid),
        ),

        margin: EdgeInsets.only(left: 16, bottom: 16, right: 16),
        height: 156,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
              child:
                CachedNetworkImage(
                  height: 156,
                  width: 150,
                  fit: BoxFit.cover,
                  imageUrl: article.image,
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 23, left: 16, right: 16),
                      // width: double.infinity,
                      width: MediaQuery.of(context).size.width - 222,
                      child: Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.textStyleSourceSansPro18(
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),

                Container(
                  width: MediaQuery.of(context).size.width - 222,
                  margin: EdgeInsets.only(top: 16),
                  child: Wrap(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            height: 16,
                            width: 16,
                            fit: BoxFit.cover,
                            imageUrl: article.author.avatar,
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: Text(article.author.name,
                            style: TextStyles.textStyleSourceSansPro10(
                                fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: CustomColors.bittersweet,
                              width: 1.0,
                              style: BorderStyle.solid),
                        ),
                        margin: EdgeInsets.only(left: 24),
                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                        child: Text(article.category.title,
                            style: TextStyles.textStyleSourceSansPro10(
                                color: CustomColors.bittersweet,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 222,
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      SvgAssets.likeSvg,
                      Container(
                        margin: EdgeInsets.only(right: 18.67),
                        child: Text(controller.numberFormat(article.likes_count)),
                      ),
                      SvgAssets.commentSvg,
                      Container(
                        child: Text(controller.numberFormat(article.comments_count)),
                      ),
                      Spacer(),
                      SvgAssets.bookmarkSvg,
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )
      ,
    );
  }
}
