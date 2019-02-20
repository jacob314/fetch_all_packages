import 'node.dart';
import 'treebase.dart';

class TreeIterator<T>{
  TreeBase _tree;
  List _ancestors;
  Node _cursor;
  TreeIterator(
    TreeBase tree
  ){
    this._tree = tree;
    this._ancestors = [];
    this._cursor = null;
  }
  T data(){
    return this._cursor != null ? this._cursor.data  : null;
  }
  Node getCursor(){
    return this._cursor;
  }
  void setCursor(
    Node cursor
  ){
    this._cursor = cursor;
  }
  List getAncestors(){
    return this._ancestors;
  }
  T next(){
    if(this._cursor == null){
      Node root = this._tree.root;
      if(root != null){
        this._minNode(root);
      }
    }
    else{
      if(this._cursor.right == null){
        Node save;
        do{
          save = this._cursor;
          if(this._ancestors.length > 0){
            this._cursor = this._ancestors.removeAt(0);
          }
          else{
            this._cursor = null;
            break;
          }
        }while(this._cursor.right == save);
      }
      else{
        this._ancestors.add(this._cursor);
        this._minNode(this._cursor.right);
      }
    }
    return this._cursor != null ? this._cursor.data : null;
  }
  T prev(){
    if(this._cursor == null){
      Node root = this._tree.root;
      if(root != null){
        this._maxNode(root);
      }
    }
    else{
      if(this._cursor.left == null){
        Node save;
        do{
          save = this._cursor;
          if(this._ancestors.length > 0){
            this._cursor = this._ancestors.removeAt(0);
          }
          else{
            this._cursor = null;
            break;
          }
        }while(this._cursor.left == save);
      }
      else{
        this._ancestors.add(this._cursor);
        this._maxNode(this._cursor.left);
      }
    }
    return this._cursor != null ? this._cursor.data : null;
  }
  void _minNode(
    Node start
    ){
      while(start.left != null){
        this._ancestors.add(start);
        start = start.left;
      }
      this._cursor = start;
    }
  void _maxNode(
    Node start
    ){
      while(start.right != null){
        this._ancestors.add(start);
        start = start.right;
      }
      this._cursor = start;
    }
}