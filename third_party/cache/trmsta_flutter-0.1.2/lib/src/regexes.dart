library trmsta.regexes;

//Google Maps array row regex — bike counts and locations
final RegExp rall = new RegExp(
    r"Stacja nr ? (\d{1,2}) ? ? ? ? ?</br> ? ? ? ? ? ?Dostępne rowery: (\d{1,2}) ? ? ? ?</br> ? ? ? ?Wolne sloty (\d{1,2}) ', (\d+\.\d+) , (\d+\.\d+) , 'http");

const NRSTA = 1;
const DOSTROW = 2;
const WOLROW = 3;
const LATIND = 4;
const LONIND = 5;

//Clickable links for stations — addresses
final RegExp rdall = new RegExp(
    r'google.maps.event.trigger.gmarkers\[(\d{1,2})\]..click.....<b> ? ? ? ?Stacja nr\. (\d{1,2})\. ([^\f\t\n\r\v\<\>]{4,}?) {0,5}?..b\> {0,8}?\<\/a\>');
const GMARKERS = 1;
const STACNUMBER = 2;
const ADDRIND = 3;
