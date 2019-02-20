# LesSQL

LesSQL  is a flutter plugin for sqlite.

## Getting started

### 1.Import LesSQL

```dart
import 'package:lessql/lessql.dart';
```

### 2.Init databse

**Define DB**

```dart
class FooDB extends LesDB{

  @override
  String getName() {
    return 'foo_db';
  }

  @override
  int getVersion() {
    return 1;
  }

}
```

**Define table**

```dart
class FooTable1 extends LesTable{

  @override
  List<String> getColumnNames() {
    return ['c1','c2','c3','c4'];
  }

  @override
  List<String> getColumnTypes() {
    return [Contract.TYPE_NUMBER,Contract.TYPE_NUMBER,Contract.TYPE_NUMBER,Contract.TYPE_NUMBER,];
  }

  @override
  String getTableName() {
    return 'table1';
  }
  @override
  List<int> getPrimaryColumnIndexes() {
    return [1];
  }

  @override
  String getAutoIncrementID(){
    return "id";
  }
}
```

**Init database**

```dart
LesSQL.initLesDB(new FooDB(), [new FooTable1(),new FooTable2()]);
```

**Insert**

LesTable and LesEntity must correspond one-to-one

```dart
class FooEntity1 extends LesEntity{

  String c1;
  int c2;
  int c3;
  int c4;

  FooEntity1(this.c1,this.c2,this.c3,this.c4);

  @override
  List getValues() {
    return [c1,c2,c3,c4];
  }
}

Random random = new Random();
FooEntity1 entity1 = new FooEntity1(random.nextInt(10000).toString(),
                     random.nextInt(10000), 
                     random.nextInt(10000), 
                     random.nextInt(10000));
LesSQL.insert(new FooTable1(), entity1.getValues()).then(_updateDes);
```

## License

```
   Copyright 2017 Qinglian.Zhang

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
