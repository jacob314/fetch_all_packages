# simple_step_history


## A simple steps history fetcher.
- iOS with CMPedometer API
- Android with GoogleFit API

## Functionality: 
- Request Authorization
'SimpleStepHistory.requestAuthorization()'
- Check is steps available or not
'SimpleStepHistory.isStepsAvailable'
- Fetch steps history by date
'SimpleStepHistory.getStepsForDay(dateStr: 'yyyy-MM-dd')'

## Note
- Make sure to add privacy request string in iOS info.plist
- Make sure to add GoogleFit API in your google developer console