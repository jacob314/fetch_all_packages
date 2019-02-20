# mobiprint3


`This is a simple unofficial plugin to enable basic printing functionality on the mobiwire mobiprint3 device`

Feel free to make contributions to the package.

## Getting Started

### In your files
> import   'package:mobiprint3/mobiprint3.dart';


`The responses returned are in the format Map<String,dynamic>`

_sample response_
> 
    { "success" : true, "message" : "1" }


### To print basic text
>  print(String txt);

e.g 

> 
    Map<String,dynamic> printResponse = await Mobiprint3.print('Hello From flutter\n\n');
    



### To print an image/bitmap
> custom(String text, Integer size);

e.g 

> 
    Map<String,dynamic> printResponse = await Mobiprint3.custom('Headers',2);

`size 1 to 3 `


### To print an image/bitmap
`Not Yet functional`
> printImage(String image_src )

e.g 

> 
    not functioning -- pending implementation


### To check if paper is loaded (or if is in printer mode)
> checkPaper();
e.g
>
    Map<String,dynamic> printResponse = await Mobiprint3.checkPaper();

### To print a space
> space();
e.g
>   
    Map<String,dynamic> printResponse = await Mobiprint3.space();

### End the printing session [print two terminating lines]
> end();
e.g
>
    Map<String,dynamic> printResponse = await Mobiprint3.end();

