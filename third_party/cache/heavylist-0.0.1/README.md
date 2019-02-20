# heavylist

An asynchronous or delayed loop

## Getting Started

# A asynchronous,or delayed loop
    HeavyList<int> abc = new HeavyList<int>([1, 2, 3]);
      abc.loop(new Duration(seconds: 1), (List<int> origin) {
        print(origin);
      }, (int item, Function resume) {
        //simulating an asynchronous call
        new Timer(new Duration(seconds: 1), () {
          print(item);
          //move to next item
          resume();
        });
      });
# A delayed loop
    HeavyList<int> abc = new HeavyList<int>([1, 2, 3]);
      abc.loop(new Duration(seconds: 1), (List<int> origin) {
        print(origin);
      }, (int item, Function resume) {
          print(item);
          //move to next item
          resume();
      });
