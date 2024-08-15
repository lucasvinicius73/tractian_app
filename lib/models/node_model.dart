class Node<Model> {
  Model data;
  List<Node<Model>> children;

  Node(this.data) : children = [];
}
