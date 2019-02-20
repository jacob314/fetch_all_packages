import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:box2d_flame/box2d.dart' as b2d;

/// An ordered pair representation (point, position, offset).
///
/// It differs from the default implementations provided (math.Point and ui.Offset) as it's mutable.
/// Also, it offers helpful converters and a some useful methods for manipulation.
/// It always uses double values to store the coordinates.
class Position {
  /// Coordinates
  double x, y;

  /// Basic constructor
  Position(this.x, this.y);

  /// Creates a point at the origin
  Position.empty() : this(0.0, 0.0);

  /// Creates converting integers to double.
  ///
  /// Internal representation is still using double, the conversion is made in the constructor only.
  Position.fromInts(int x, int y) : this(x.toDouble(), y.toDouble());

  /// Creates using an [ui.Offset]
  Position.fromOffset(ui.Offset offset) : this(offset.dx, offset.dy);

  /// Creates using an [ui.Size]
  Position.fromSize(ui.Size size) : this(size.width, size.height);

  /// Creates using an [math.Point]
  Position.fromPoint(math.Point point) : this(point.x, point.y);

  /// Creates using another [Position]; i.e., clones this position.
  ///
  /// This is usefull because this class is mutable, so beware of mutability issues.
  Position.fromPosition(Position position) : this(position.x, position.y);

  /// Creates using a [b2d.Vector2]
  Position.fromVector(b2d.Vector2 vector) : this(vector.x, vector.y);

  Position add(Position other) {
    this.x += other.x;
    this.y += other.y;
    return this;
  }

  Position minus(Position other) {
    return this.add(other.clone().opposite());
  }

  Position opposite() {
    return this.times(-1.0);
  }

  Position times(double scalar) {
    this.x *= scalar;
    this.y *= scalar;
    return this;
  }

  double dotProduct(Position p) {
    return this.x * p.x + this.y * p.y;
  }

  double length() {
    return math.sqrt(math.pow(this.x, 2) + math.pow(this.y, 2));
  }

  Position rotate(double angle) {
    double nx = math.cos(angle) * this.x - math.sin(angle) * this.y;
    double ny = math.sin(angle) * this.x + math.cos(angle) * this.y;
    this.x = nx;
    this.y = ny;
    return this;
  }

  ui.Offset toOffset() {
    return new ui.Offset(x, y);
  }

  ui.Size toSize() {
    return new ui.Size(x, y);
  }

  math.Point toPoint() {
    return new math.Point(x, y);
  }

  b2d.Vector2 toVector() {
    return new b2d.Vector2(x, y);
  }

  Position clone() {
    return new Position.fromPosition(this);
  }

  @override
  String toString() {
    return '($x, $y)';
  }

  static ui.Rect rectFrom(Position topLeft, Position size) {
    return new ui.Rect.fromLTWH(topLeft.x, topLeft.y, size.x, size.y);
  }

  static ui.Rect bounds(List<Position> pts) {
    double minx = pts.map((e) => e.x).reduce(math.min);
    double maxx = pts.map((e) => e.x).reduce(math.max);
    double miny = pts.map((e) => e.y).reduce(math.min);
    double maxy = pts.map((e) => e.y).reduce(math.max);
    return new ui.Rect.fromPoints(
        new ui.Offset(minx, miny), new ui.Offset(maxx, maxy));
  }
}
