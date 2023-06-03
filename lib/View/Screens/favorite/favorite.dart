import 'package:flocdock/View/Screens/group/group_view.dart';
import 'package:flocdock/View/Screens/menu/drawer.dart';
import 'package:flocdock/View/Screens/profile/profile_view.dart';
import 'package:flocdock/View/Widgets/advertisement_container.dart';
import 'package:flocdock/View/Widgets/profile_widget.dart';
import 'package:flocdock/View/base/bottom_navbar.dart';
import 'package:flocdock/View/base/custom_appbar.dart';
import 'package:flocdock/View/base/custom_snackbar.dart';
import 'package:flocdock/View/base/loading_dialog.dart';
import 'package:flocdock/constants/constants.dart';
import 'package:flocdock/constants/dimensions.dart';
import 'package:flocdock/constants/styles.dart';
import 'package:flocdock/mixin/data.dart';
import 'package:flocdock/models/profile&Group/profile_group_model.dart';
import 'package:flocdock/services/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../models/groupModel/event_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);


  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool isSearch =false;
  TextEditingController searchController=TextEditingController();
  List<ProfileGroupDetail>? profileGroup=[];


  String selectedSegment = 'Favorite';
  bool isToday = false;
  List<GroupData>? groupData=[];
  List<GroupData>? groupData1=[];
  void getGroups() async {
    print("AppData().userdetail!.latitude");
    print(AppData().userdetail!.latitude);
    print(AppData().userdetail!.longitude);
    // openLoadingDialog(context, "Loading");
    print("my id: ${AppData().userdetail!.usersId}");

    var response;
    response = await DioService.post('get_all_groups', {
      "usersId":AppData().userdetail!.usersId,
      "userLat":AppData().userdetail!.latitude.toString(),
      "userLong":AppData().userdetail!.longitude.toString(),
    });


    if(response['status']=='success'){

      print("data11: ${response["data"]}");
      var jsonData= response['data'] as List;

      groupData=jsonData.map((e) => GroupData.fromJson(e)).toList();
      print("id: ${AppData().userdetail!.usersId}");
      print("id1: ${groupData![0].usersId}");

      setState(() {});
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }

  }
  void getMyGroups() async {
    print("AppData().userdetail!.latitude");
    print(AppData().userdetail!.latitude);
    print(AppData().userdetail!.longitude);
    // openLoadingDialog(context, "Loading");
    print("my id 1: ${AppData().userdetail!.usersId}");

    var response;
    response = await DioService.post('get_user_groups', {
      "usersId":AppData().userdetail!.usersId.toString()
    });


    if(response['status']=='success'){
     print("hiiiiiiiiii");
      print("data11: ${response["data"]}");
      var jsonData= response['data'] as List;

      groupData1=jsonData.map((e) => GroupData.fromJson(e)).toList();
      print("id: ${AppData().userdetail!.usersId}");
      print("id1: ${groupData![0].usersId}");

      setState(() {});
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMyGroups();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getFavouriteUsersGroups();
    });
  }

  bool isAll = false;

  void isSelectedEvents() async {
    openLoadingDialog(context, "loading");
    selectedSegment = "Favorite";
    isAll = true;
    setState(() {});
    Navigator.of(context).pop();
  }


  void isSelectedBusiness() async {
    openLoadingDialog(context, "loading");
    isToday = true;
    selectedSegment = 'My Groups';
    setState(() {});
    // await getNearbyBusiness(isReFresh: true);
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KbgBlack,
      drawer: MyDrawer(),
      appBar: CustomAppbar(pageName: 'Favorite', description: "Groups and Profiles",pageTrailing: "",),
      bottomNavigationBar: BottomBar(pageIndex: 3,),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: [

                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(0xFFE5E8EF),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: (selectedSegment == 'Favorite')
                                  ? BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: KBlue),
                                  borderRadius: BorderRadius.circular(30))
                                  : BoxDecoration(),
                              child: TextButton(
                                onPressed: () => isSelectedEvents(),
                                child: Text(
                                  'Favorite',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: (selectedSegment == 'My Groups')
                                  ? BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: KBlue),
                                  borderRadius: BorderRadius.circular(30))
                                  : BoxDecoration(),
                              child: TextButton(
                                  onPressed: () => isSelectedBusiness(),
                                  child: Text(
                                    "My Groups",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),



                    selectedSegment=="Favorite"?
                    StaggeredGrid.count(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      crossAxisCount: 3,
                      children: [
                        for(int i=0;i<profileGroup!.length;i++)
                          profileGroup![i].objectType=="Group"?
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: InkWell(
                              onTap: () => Get.to(GroupView(groupId: profileGroup![i].groupId,)),
                              child: GroupWidget(
                                img: profileGroup![i].picture??'',
                                groupName: profileGroup![i].name??'',
                                distance: profileGroup![i].distanceAway!.toPrecision(2).toString(),
                                groupMembers: profileGroup![i].totalActiveMembers.toString(),
                              ),
                            ),
                          ):
                          StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: InkWell(
                                onTap: () => Get.to(ProfileView(userId: profileGroup![i].usersId,)),
                                child: ProfileWidget(
                                    img: profileGroup![i].picture??'',
                                    profileName: profileGroup![i].name??'',
                                    distance: profileGroup![i].distanceAway!.toPrecision(2).toString(),
                                  isOnline: profileGroup![i].isOnline
                                ),
                              )
                          ),

                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //   crossAxisCellCount: 2,
                        //   mainAxisCellCount: 1,
                        //   child: GroupContainer(
                        //       img: groupDummyData[0].img,
                        //       groupName: groupDummyData[0].groupName,
                        //       distance: groupDummyData[0].distance,
                        //       groupMembers: groupDummyData[0].groupMember,
                        //     index: 1
                        //   ),
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //     crossAxisCellCount: 1,
                        //     mainAxisCellCount: 1,
                        //     child: ProfileWidget(
                        //         img: profileDummyData[0].Img,
                        //         profileName: profileDummyData[0].profileName,
                        //         distance: profileDummyData[0].distance,
                        //         col: profileDummyData[0].col
                        //     )
                        // ),
                        // StaggeredGridTile.count(
                        //   crossAxisCellCount: 2,
                        //   mainAxisCellCount: 1,
                        //   child: GroupContainer(
                        //       img: groupDummyData[0].img,
                        //       groupName: groupDummyData[0].groupName,
                        //       distance: groupDummyData[0].distance,
                        //       groupMembers: groupDummyData[0].groupMember,
                        //     index: 1
                        //   ),
                        // ),
                      ],
                    ):
                    Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: GridView.builder(

                              physics: BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 4 / 2,
                                crossAxisSpacing: 13,
                                mainAxisSpacing: 13,
                              ),
                              itemCount: groupData1!.length,
                              itemBuilder: (BuildContext ctx, index){
                                print("groupData1 ${groupData1![index].usersId}");

                                return GestureDetector(
                                  onTap: () => Get.to(GroupView(groupId: groupData1![index].groupId,)),
                                  child:  GroupWidget(
                                    img: groupData1![index].coverPhoto!,
                                    groupName: groupData1![index].category!.category!,
                                    distance: groupData1![index].distanceAway!.toPrecision(2).toString(),
                                    groupMembers: groupData1![index].totalAttendees.toString(),
                                  )
                                );
                              }
                          ),
                    ),
                    //             StaggeredGrid.count(
                    //               mainAxisSpacing: 4,
                    //               crossAxisSpacing: 4,
                    //               crossAxisCount: 3,
                    //               children: [
                    //                 for(int index=0;index<6;index++)
                    //                   mixDummyData[index].isProfile?
                    //                     StaggeredGridTile.count(
                    //                         crossAxisCellCount: 1,
                    //                         mainAxisCellCount: 1,
                    //                         child: ProfileContainer(
                    //                             img: profileDummyData[index].Img,
                    //                             profileName: profileDummyData[index].profileName,
                    //                             distance: profileDummyData[index].distance,
                    //                             col: profileDummyData[index].col
                    //                         )
                    //                     ):
                    //                     StaggeredGridTile.count(
                    //                       crossAxisCellCount: 2,
                    //                       mainAxisCellCount: 1,
                    //                       child: GroupContainer(
                    //                           img: groupDummyData[index].img,
                    //                           groupName: groupDummyData[index].groupName,
                    //                           distance: groupDummyData[index].distance,
                    //                           groupMembers: groupDummyData[index].groupMember),
                    //                     )
                    //               ],
                    // ),
                  ],
                ),
              ),
            ),
            AdvertisementContainer(context: context)
          ],
        ),
      ),
    );
  }

  void getFavouriteUsersGroups() async {
    openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('get_favourite_users_groups', {
      "usersId":AppData().userdetail!.usersId.toString(),
      "userLat":AppData().userdetail!.latitude.toString(),
      "userLong":AppData().userdetail!.longitude.toString()
    });
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      profileGroup=jsonData.map((e) => ProfileGroupDetail.fromJson(e)).toList();
      Navigator.pop(context);
      setState(() {});
    }
    else{
      Navigator.pop(context);
      print(response['message']);
      showCustomSnackBar(response['message']);
    }
  }
}
