import 'package:flocdock/View/Screens/Home/home_page.dart';
import 'package:flocdock/View/Screens/discover/discover_page.dart';
import 'package:flocdock/View/Screens/favorite/favorite.dart';
import 'package:flocdock/View/Screens/inbox/inbox_page.dart';
import 'package:flocdock/View/Widgets/my_spacing.dart';
import 'package:flocdock/View/Widgets/my_text.dart';
import 'package:flocdock/constants/constants.dart';
import 'package:flocdock/constants/images.dart';
import 'package:flocdock/mixin/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../models/inbox/inbox_model.dart';
import '../../services/dio_service.dart';
import 'loading_dialog.dart';


class BottomBar extends StatefulWidget {
  int pageIndex;
  int? inboxIndex;
  BottomBar({Key? key,this.pageIndex=0,this.inboxIndex}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int pageIndex=0;
  List<InboxDetail> inboxMessages=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.pageIndex);
    // print(widget.inboxIndex);
    getInboxList();
    print("inbox${inboxMessages.length}");
    pageIndex=widget.pageIndex;
  }
  void getInboxList() async {
    // openLoadingDialog(context, "Loading");
    print("husdhbcsucb");
    var response;
    response = await DioService.post('get_inbox_list', {
      "userId":AppData().userdetail!.usersId.toString()
    });
    print(response);
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      inboxMessages=jsonData.map((e) => InboxDetail.fromJson(e)).toList();
      print("inbox${inboxMessages.length}");

      setState(() {});
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      //showCustomSnackBar(response['message']);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GetPlatform.isIOS? 68:60,
      color: KPureBlack,
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding:  EdgeInsets.only(bottom: GetPlatform.isIOS?10.0:0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                pageIndex=0;
                  Get.to(HomePage());
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.nearby,color: pageIndex == 0?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "NEARBY",
                    color: pageIndex == 0?KWhite:Kunactive,
                    size: pageIndex == 0?12:10,
                    fontFamily: "Proxima",
                    weight: FontWeight.bold,
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                  pageIndex = 1;
                  Get.to(InboxPage());
              },
              child: Column(
                children: [
                  Stack(children: [
                    SvgPicture.asset(Images.inbox,color: pageIndex == 1?KWhite:Kunactive,),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          color: Colors.green,
                        ),
                   child: Text(inboxMessages.length.toString()?? "0",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                      ),
                    )
                   ],
                  ),

                  spaceVertical(5),
                  MyText(
                    text: "INBOX",
                    fontFamily: "Proxima",
                    weight: FontWeight.bold,
                    color: pageIndex == 1?KWhite:Kunactive,
                    size: pageIndex == 1?12:10,
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  pageIndex = 2;
                  Get.to(DiscoverPage());
                });
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.discover,color: pageIndex == 2?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "DISCOVER",
                    fontFamily: "Proxima",
                    weight: FontWeight.bold,
                    color: pageIndex == 2?KWhite:Kunactive,
                    size: pageIndex == 2?12:10,
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  pageIndex = 3;
                  Get.to(FavoritePage());
                });
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.favourites,color: pageIndex == 3?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "FAVOURITES",
                    fontFamily: "Proxima",
                    weight: FontWeight.bold,
                    color: pageIndex == 3?KWhite:Kunactive,
                    size: pageIndex == 3?12:10,
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}


