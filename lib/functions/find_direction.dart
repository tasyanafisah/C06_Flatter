import 'dart:math';

class Coordinate {
  double x;
  double y;

  Coordinate(this.x, this.y);
}

Coordinate optimizeCoordinates(Coordinate initialCoordinates, double epsilon) {
  const int N = 2; // You may adjust the value of N based on your needs
  const int maxIterations =
      100; // Set a maximum number of iterations to avoid infinite loops

  Coordinate currentCoordinates = initialCoordinates;
  double delta = 1.0; // Initial value for delta

  int iteration = 0;

  while (delta >= epsilon && iteration < maxIterations) {
    // Create 2N points by varying delta/2
    List<Coordinate> points = [];
    for (int i = 0; i < N; i++) {
      double deltaX = Random().nextDouble() * delta - delta / 2;
      double deltaY = Random().nextDouble() * delta - delta / 2;
      points.add(Coordinate(
        currentCoordinates.x + deltaX,
        currentCoordinates.y + deltaY,
      ));
    }

    // Evaluate function values at all points (you need to define your function)
    double minValue = double.infinity;
    Coordinate minPoint = currentCoordinates;
    for (Coordinate point in points) {
      double functionValue =
          evaluateFunction(point); // You need to implement evaluateFunction
      if (functionValue < minValue) {
        minValue = functionValue;
        minPoint = point;
      }
    }

    // Update current coordinates
    if (minPoint != currentCoordinates) {
      currentCoordinates = minPoint;
    } else {
      // If the minimum point is the same as the current coordinates, reduce delta
      delta /= 2;
    }

    iteration++;
  }

  return currentCoordinates;
}

double evaluateFunction(Coordinate point) {
  return point.x * point.x + point.y * point.y;
}
