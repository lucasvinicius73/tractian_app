class Node<T> {
  T data;
  List<Node<T>> children;

  Node(this.data) : children = [];
}
