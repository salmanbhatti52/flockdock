import 'package:flocdock/models/groupModel/category_model.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';
import '../../../../models/user_model/profile_model.dart';
import '../../../../models/user_model/signup_model.dart';
import '../../create_event/widget/value_container.dart';

class mytribe extends StatefulWidget {

  int length;
  final List<Tribe>? names;
  //var names;
  mytribe(

      {Key? key, required this.length, required this.names}
      ) : super(key: key);

  @override
  State<mytribe> createState() => _mytribeState();
}

class _mytribeState extends State<mytribe> {
  ProfileDetail profileDetail=ProfileDetail(ethnicities: [],bodyTypes: [],positions: [],relationships: [],seeking: [],tribes: []);
  UserDetail userDetail=UserDetail(userSeeking: [],userTribes: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     // getUserProfileDetail();
      print("lengthhgjgj:");
      print(widget.length);
      print('value');
      print(widget.names);
      //getPredefinedProfileDetail();
      //selectedDate = DateTime.parse(userDetail.birthday.toString());
      // DOB = userDetail.birthday.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KbgBlack,
      appBar: AppBar(title: Text(
        'My Tribes',
        style: TextStyle(color: KWhite),
      ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black54,
      ),
      body: ListView.builder(
          itemCount: widget.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(

                trailing: Icon(Icons.check,color: Colors.white,),
                title: Text(widget.names![0].toString(),style: TextStyle(color: Colors.white),));
          }),

    );

  }


}
