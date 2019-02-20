تاریخ شمسی برای دارت و فلاتر

- [جهت استفاده از مبدل همراه با تقویم و Date Picker از این پکیج استفاده نماید](https://pub.dartlang.org/packages/jalali_calendar)



تبدیل تاریخ میلادی به شمسی به وسیله این کتابخانه قادر هستید که تاریخ های میلادی را به شمسی و بلعکس تبدیل کنید
در بروز رسانی های بعدی مواردی بیشتری به کتاب خانه اضافه خواهند شد 
## استفاده از کتاب خانه 

چند مثال ساده

افزودن پارس تاریخ مشخص و دریافت اطلاعات ان بجای تاریخ فعلی

```dart
import 'package:PersianDate/PersianDate.dart';

main() {
  
  PersianDate persianDate = PersianDate(gregorian: "1989-01-29");
  //PersianDate persianDate = PersianDate(gregorian: "1989-01-29");
    print("Now ${persianDate.getDate}");
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
     
 
 // برگرداندن یک تاریخ خاص از سال میلادی
    var Gdate = new DateTime(1989,08,21);
    print("${persianDate.parse(Gdate.toString(),"/")}"); // اگر جدا کننده قرار داده نشود به صورت یک لیست بر میگرداند
    print("${persianDate.parse(Gdate.toString())}"); // 
  
  // با فرمت دلخواه
  print("${persianDate.parseToFormat(Gdate.toString())}");
  print("${persianDate.parseToFormat(Gdate.toString(),"yyyy-m-dd h:n:ss")}");
  
     // تبدیل تاریخ شمسی به میلادی اگر جدا کننده نداشته باشه به صورت یک لیست بر میگرداند
print(persianDate.jalaliToGregorian(1397, 09, 12));

    
  }
```

کلید فرمت های که میتوانید استفاده کنید

yyyy // 4 عدد سال

yy // 2 عدد سال

mm // 2 عدد ماه اگر ماه تک رقمی باشد 0 در اول ان قرار میدهد

m // 1 عدد ماه اگر ماه تک رقمی باشد 0 قرار نمیدهد

MM // ماه به صورت حروفی کامل

M // ماه به صورت حروفی کوتاه

dd // روز به صورت 2 عددی

d // روز به صورت تک رقمی برای روز های زیر 10

w // عدد هفته از ماه را بر میگرداند

DD // نام روز

D // نام روز

hh // ساعت با دو رقم اگر ساعت تک رقمی باشد 0 ابتدای عدد قرار میدهد فرمت 12 ساعته

h // ساعت با تک رقم فرمت 12 ساعته 

HH // ساعت با 2 رقم فرمت 24 ساعته 

H // ساعت با تک رقم فرمت 24 ساعته

nn // نمایشه دقیقه به صورت دو رقمی

n // نمایشه دقیقه به صورت تک رقمی

ss // نمایش ثانیه دو رقمی

s  // نمایش ثانیه تک رقمی

SSS // نمایش میلی ثانیه

S // نمایش میلی ثانیه

uuu // نمایش میکرو ثانیه

u // نمایش میکرو ثانیه

am // نمایش وقت به صورت کوتاه 

AM // نمایش وقت به صورت کامل


## گزارش اشکال

در صورت وجود هر گونه مشکل از طریق ایمیل زیر با ما در میان بگذارید[j.zobeidi89@gmail.com][tracker].

[tracker]: mailto:j.zobeidi89@gmail.com
