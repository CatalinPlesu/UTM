import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab_4/pages/home/home_controller.dart';
import 'package:lab_4/pages/home/widgets/featured/featured_card.dart';
import 'package:lab_4/resources/custom_collors.dart';
import 'package:lab_4/resources/text_styles.dart';

class Featured extends StatefulWidget {
  Featured({super.key});

  @override
  State<Featured> createState() => FeaturedState();
}

class FeaturedState extends State<Featured> {
  HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 0), //MediaQuery.of(context).viewPadding.top),
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: [
              Text("Featured",
              style: TextStyles.textStyleSourceSansPro20(color: CustomColors.pickledBluewood ,fontWeight: FontWeight.w600)),
              Spacer(),
              Text("See all",
                  style: TextStyles.textStyleSourceSansPro16(fontWeight: FontWeight.w600)),
            ],
          )
        ),
        Container(
          height: 252,
          child: ListView.builder(
            itemCount: controller.featured.value.length,
            scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index){
              return FeaturedCard(featured: controller.featured.value[index]);
        }
        ),),
      ],
    ));
  }
}
