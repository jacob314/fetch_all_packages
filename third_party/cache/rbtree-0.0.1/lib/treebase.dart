import 'node.dart';
import 'iterator.dart';
class TreeBase<T>{
  Node<T> root;
  int size;
  Function _comparator;
  TreeBase(
      int comparator(T a,T b)
    ){
      this._comparator = comparator;
    }
  void clear(){
    this.root = null;
    this.size = 0;
  }
  T find(
    T data
  ){
    Node<T> res = this.root;
    while(res != null){
      int c = this._comparator(data,res.data);
      if(c == 0){
        return res.data;
      }
      else{
        res = res.getChild(c > 0);
      }
    }
    return null;
  }
  TreeIterator findIter(
    T data
  ){
    Node<T> res = this.root;
    TreeIterator iter = this.iterator();
    while(res != null){
      int c = this._comparator(data,res.data);
      if(c == 0){
        iter.setCursor(res);
        return iter;
      }
      else{
        iter.getAncestors().add(res);
        res = res.getChild(c>0);
      }
    }
    return null;
  }
  TreeIterator lowerBound(
    dynamic item
  ){
    Node<T> cur = this.root;
    TreeIterator iter = this.iterator();
    Function cmp = this._comparator;
    while(cur!=null){
      int c = cmp(item,cur.data);
      if(c==0){
        iter.setCursor(cur);
        return iter;
      }
      iter.getAncestors().add(cur);
      cur = cur.getChild(c>0);
    }
    for(int i = iter.getAncestors().length -1;i>=0;--i){
      Node<T> cur = iter.getAncestors()[i];
      if(cmp(item,cur.data)<0){
        iter.setCursor(cur);
        iter.getAncestors().length = i;
        return iter;
      }
    }
    iter.getAncestors().length = 0;
    return iter;
  }
  TreeIterator upperBound(
    dynamic item
  ){
    TreeIterator iter = this.lowerBound(item);
    Function cmp = this._comparator;
    while(iter.data()!=null&&cmp(iter.data(),item)==0){
      iter.next();
    }
    return iter;
  }
  T min(){
    Node<T> res = this.root;
    if(res == null){
      return null;
    }
    while(res.left != null){
      res = res.left;
    }
    return res.data;
  }
  T max(){
    Node<T> res = this.root;
    if(root == null){
      return null;
    }
    while(res.right != null){
      res  = res.right;
    }
    return res.data;
  }
  TreeIterator iterator(){
    return new TreeIterator<T>(this);
  }
  void each(bool cb(T data)){
    TreeIterator it = this.iterator();
    T data;
    while((data = it.next()) != null)
    {
      if(cb(data) == false){
        return;
      }
    }
  }
  void reach(bool cb(T data)){
    TreeIterator it = this.iterator();
    dynamic data;
    while((data = it.prev()) != null){
      if(cb(data) == false){
        return;
      }
    }
  }
}