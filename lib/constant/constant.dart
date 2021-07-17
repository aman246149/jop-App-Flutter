import 'package:flutter/material.dart';

var largeFontSize = 30.0;

var kmediumTextStyle = TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: 'Roboto-Regular');

var kAppBarStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans-Regular',
    fontSize: 25,
    fontWeight: FontWeight.w700);

String findYearAndMonth() {
  var month = DateTime.now().month;
  var day = DateTime.now().day;
  String monthInString = "";
  var year = DateTime.now().year;

  switch (month) {
    case 1:
      monthInString = "jan";
      break;
    case 2:
      monthInString = "feb";
      break;
    case 3:
      monthInString = "march";
      break;
    case 4:
      monthInString = "april";
      break;
    case 5:
      monthInString = "may";
      break;
    case 6:
      monthInString = "june";
      break;
    case 7:
      monthInString = "july";
      break;
    case 8:
      monthInString = "august";
      break;
    case 9:
      monthInString = "sept";
      break;
    case 10:
      monthInString = "oct";
      break;
    case 11:
      monthInString = "nov";
      break;
    case 12:
      monthInString = "dec";
      break;
    default:
  }
    
    var customdate=" ${day} ${monthInString} ${year}";
    return customdate;

}