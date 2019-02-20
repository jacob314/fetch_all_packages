class Node<T>{
  T data;
  Node left;
  Node right;
  bool red;
  Node(
    T data
  ){
    this.right = null;
    this.left = null;
    this.data = data;
    this.red = true;
  }
  Node getChild(
    bool dir
    ){
    return dir ? this.right : this.left;
  }
  void setChild(
    bool dir,
    Node value
  ){
    if(dir){
      this.right = value;
    }
    else{
      this.left = value;
    }
  }
}