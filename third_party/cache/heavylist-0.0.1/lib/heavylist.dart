library heavylist;

import 'dart:async';
//used for timed foreach
class HeavyList<T>{
  List<T> _list;
  int index;
  int length;
  List<T> _registered;
  Timer t;
  StreamController<dynamic> _removeController;
  HeavyList(
    List<T> list
    ){
    this._registered = new List<T>();
    _removeController = new StreamController<dynamic>();
    this._list = list;
    this.index = -1;
    this.length = this._list.length;
  }
  void addItemAt(dynamic item,int index){
    this._list.insert(index, item);
  }
  void addItem(item){
    this._list.add(item);
    this.length += 1;
  }
  void removeItem(item){
    int index = _list.indexOf(item);
    if(index >= 0){
      _removeController.add(this._list.removeAt(index));
      this.length -= 1;
    }
  }
  Stream<dynamic> get clear{
    return _removeController.stream;
  }
  void loop(
    Duration time,
    Function finished(List<T> completion),
    Function each(T item,Function forward)
  ){
    var resume,h;
    resume = (){
      t = new Timer(time,h);
    };
    h = (){
      this.index+= 1;
      if(this.index<this.length){
        this._registered.add(this._list[this.index]);
      }
      this.index == this.length ? finished(this._list) : each(this._list[this.index],resume);
    };
    resume();
  }
  void empty(){
    this.stop();
    this._list = new List<T>();
    this.index = -1;
    this.length = 0;
  }
  void stop(){

    if(t!=null){
      t.cancel();
    }
  }
  void clearRegistered(){
    this._registered.forEach((item){
       this._list.remove(item);
    });
    this._registered = new List<T>();
    this.index  = -1;
    this.length = this._list.length;
  }
  List<T> getList(){
    return this._list;
  }
  int getSize(

      ){
    return this._list.length;
  }
}