import 'package:persian_date/persian_date.dart';

main() {

  PersianDate persianDate = PersianDate(gregorian: "1989/01/29");
  //PersianDate persianDate = PersianDate(gregorian: "1989-01-29");

  print("Date ${persianDate.getDate}");
  print("Now ${persianDate.now}");
  print(persianDate.hour);
  print("year ${persianDate.year}");
  print("isHoliday ${persianDate.isHoliday}");
  print("isHoliday ${persianDate.weekdayname}");
  print(persianDate.monthname); // نام ماه
  print(persianDate.month); // ماه
  print(persianDate.day); // روز
  print(persianDate.hour);// ساعت
  print(persianDate.minute);// دقیقه
  print(persianDate.second);// ثانیه
  print(persianDate.millisecond); // میلی ثانیه
  print(persianDate.microsecond);//



  print(persianDate.jalaliToGregorian(1368, 05, 30)); // تبدیل تاریخ شمسی به میلادی اگر جدا کننده نداشته باشه به صورت یک لیست بر میگرداند


  print("${persianDate.parseToFormat("2018-12-10 09:36:13","D")}");
}
