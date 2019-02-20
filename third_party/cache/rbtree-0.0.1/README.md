# redblacktree
Dart Red Black Tree
>Example usage
  ```
  Function cmp = (int a,int b){
    return a-b;
  };
  RBTree<int> tree = new RBTree<int>(
      cmp
  );
  tree.insert(1);
  tree.insert(2);
  tree.insert(3);
  tree.remove(2);
  tree.each((int item){
    print(item);
  });
```

