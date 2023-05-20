import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/mutual_fund_model.dart';

Widget customListTile(Data data, BuildContext context)
{
   var width=MediaQuery.of(context).size.width;
   var height=MediaQuery.of(context).size.height;
  return Container(
    margin:  EdgeInsets.all(width*0.02),
    padding:  EdgeInsets.all(width*0.01),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          )
        ]),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width*0.05,top:  height*0.007),
                    child: const Text("Date:",style: dateStyle,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width*0.05,top: height*0.007),
                    child: Text(data.date,style: dataStyle,),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height*0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width*0.05,bottom: height*0.007),
                    child: const Text("Nav:",style: navStyle),
                  ),
                  Padding(
                    padding:EdgeInsets.only(right: width*0.05,bottom: height*0.007),
                    child: Text(data.nav,style: dataStyle,),
                  ),
                ],
              ),
            )

      ],
    ),
  );
}