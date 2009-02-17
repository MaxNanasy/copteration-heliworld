#ifndef VECTOR3_H
#define VECTOR3_H

// A three-dimensional vector.
typedef struct {
  float x, y, z;
} Vector3;

Vector3 addV3 (Vector3 a, Vector3 b)
{
  return (Vector3) { a.x + b.x, a.y + b.y, a.z + b.z };
}

Vector3 scaleV3 (float a, Vector3 b)
{
  return (Vector3) { a * b.x, a * b.y, a * b.z };
}

#endif