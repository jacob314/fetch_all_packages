library rbtree;
import 'treebase.dart';

import 'node.dart';
class RBTree<T> extends TreeBase<T>{
    Node<T> root;
    Function _comparator;
    int size;
    RBTree(
      int comparator(T a,T b)
      ) : super(comparator) {
        this._comparator = comparator;
        this.size = 0;
      }
      bool insert(
        T data
        ){
          bool ret = false;
          if(this.root == null){
            this.root = new Node<T>(data);
            ret = true;
            this.size++;
          }
          else{
            Node<T> head = new Node<T>(null);
            bool dir = false;
            bool last = false;
            Node<T> gp;
            Node<T> ggp = head;
            Node<T> p;
            Node<T> node = this.root;
            ggp.right = this.root;
            while(true){
              if(node == null){
                node = new Node<T>(data);
                p.setChild(dir, node);
                ret = true;
                this.size++;
              }
              else if(this.isRed(node.left)&&this.isRed(node.right))
              {
                node.red = true;
                node.left.red = false;
                node.right.red = false;
              }
              if(this.isRed(node)&&this.isRed(p)){
                bool dir2 = ggp.right == gp;
                if(node == p.getChild(last)){
                  ggp.setChild(dir2, this.singleRotate(gp, !last));
                }
                else{
                  ggp.setChild(dir2, this.doubleRotate(gp, !last));
                }
              }
              int cmp = this._comparator(node.data,data);
              if(cmp == 0){
                break;
              }
              last = dir;
              dir = cmp < 0;
              if(gp != null){
                ggp = gp;
              }
              gp = p;
              p = node;
              node = node.getChild(dir);
            }
            this.root = head.right;
          }
          this.root.red = false;
          return ret;
        }
  bool remove(
    T data
  ){
    if(this.root == null){
      return false;
    }
    Node<T> head = new Node<T>(null);
    Node<T> node = head;
    node.right = this.root;
    Node<T> p;
    Node<T> gp;
    Node<T> found;
    bool dir;
    dir = true;
    while(node.getChild(dir)!=null){
      bool last;
      last = dir;
      gp = p;
      p = node;
      node = node.getChild(dir);
      int cmp = this._comparator(data,node.data);
      dir = cmp > 0;
      if(cmp == 0){
        found = node;
      }
      if(!this.isRed(node)&&!this.isRed(node.getChild(dir))){
        if(this.isRed(node.getChild(!dir))){
          Node sr = this.singleRotate(root, dir);
          p.setChild(dir, sr);
          p = sr;
        }
        else if(!this.isRed(node.getChild(!dir))){
          Node sibling = p.getChild(!last);
          if(sibling != null){
            if(!this.isRed(sibling.getChild(!last))&&this.isRed(sibling.getChild(last))){
              p.red = false;
              sibling.red = true;
              node.red = true;
            }
            else{
              bool dir2 = gp.right == p;
              if(this.isRed(sibling.getChild(last))){
                gp.setChild(dir2, this.doubleRotate(p, last));
              }
              else if(this.isRed(sibling.getChild(!last))){
                gp.setChild(dir2, singleRotate(p, last));
              }
              Node gpc = gp.getChild(dir2);
              gpc.red  = true;
              node.red = true;
              gpc.left.red = false;
              gpc.right.red = false;
            }
          }
        }
      }
    }
    if(found !=null){
      found.data = node.data;
      p.setChild(p.right == node, node.getChild(node.left == null));
      this.size--;
    }
    this.root = head.right;
    if(this.root != null){
      this.root.red = false;
    }
    return found !=null;
  }
  bool isRed(node){
    return node !=null && node.red;
  }
  Node singleRotate(
    Node root,
    bool dir
  ){
    Node save = root.getChild(!dir);
    root.setChild(!dir, save.getChild(dir));
    save.setChild(dir, root);
    root.red = true;
    save.red = false;
    return save;
  }
  Node doubleRotate(
    Node<T> root,
    bool dir
  ){
    root.setChild(!dir,this.singleRotate(root.getChild(!dir), !dir));
    return singleRotate(root,dir);
  }
}
