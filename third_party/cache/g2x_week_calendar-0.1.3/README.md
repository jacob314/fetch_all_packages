# g2x week calendar

Customizable week calendar

## image
<img src="https://raw.githubusercontent.com/Eddie66six/G2xWeekCalendar/master/example/g2x_week_calendar_example.PNG"/>

## G2xSimpleWeekCalendar customizable

    strWeekDays: 
        Abbreviation of the days of the week, beginning with Sunday
            type: List<string>
            default value ["Sun","Mon","Tues","Wed","Thurs","Fri","Sat"]
    
    format:
        Format of the date displayed in the component header
            type: String
            default value "yyyy/MM/dd"
    
    dateCallback: 
        type: typedef void
        Function that returns the date

    defaultTextStyle: 
        type: TextStyle
        default value flutter

    selectedTextStyle:
        type: TextStyle
        default value TextStyle(color: Colors.red),

    selectedBackgroundDecoration:
        type: BoxDecoration
        default value flutter
    
    backgroundDecoration: 
        type: BoxDecoration
        default value flutter

### MyDateTime
    class that contains the methods used on component