## Implementing ReaderScreen

### TextNodeWidgetFactory

- is a factory class which produces a TextNodeWidget
- it takes in:
  - **node:** text node to display
- maps `node.type` to an apporpriete [[#TextNodeWidget]], and returns the widget when the `.widget()` method is called

### TextNodeWidget

- a mixin on `Widget`
- requires the user to define a node type, and asserts that node type is the type of the that the widget has passed in
