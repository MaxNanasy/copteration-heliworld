#ifndef VECTOR3_H
#define VECTOR3_H

//#define V3(X, Y, Z) ((Vector3) { { X }, { Y }, { Z } })
#define zeroV3 (V3 ( 0, 0, 0 ))

// A three-dimensional vector.
typedef struct {
  union { float x, roll ; };
  union { float y, pitch; };
  union { float z, yaw  ; };
} Vector3;

// Two three-dimensional vectors.
typedef struct {
  Vector3 a, b;
} DoubleVector3;

// This inline function is necessary to avoid various warnings associated with initializing a Vector3.
inline Vector3 V3 (float x, float y, float z)
{
  Vector3 toReturn;
  toReturn.x = x;
  toReturn.y = y;
  toReturn.z = z;
  return toReturn;
}

Vector3 addV3 (Vector3 a, Vector3 b)
{
  return V3 ( a.x + b.x, a.y + b.y, a.z + b.z );
}

Vector3 scaleV3 (float a, Vector3 b)
{
  return V3 ( a * b.x, a * b.y, a * b.z );
}

// Input: (original vector, angles)
// Output: rotated vector
Vector3 rotateV3 (Vector3 a, Vector3 orientation)
{

  float
    cR = cos (orientation.roll ),
    cP = cos (orientation.pitch),
    cY = cos (orientation.yaw  ),
    sR = sin (orientation.roll ),
    sP = sin (orientation.pitch),
    sY = sin (orientation.yaw  )
    ;
  
  return V3 ( a.x *    cP  * cY + a.y * (- cR * sY + sR * sP * cY) + a.z * (  sR * sY + cR * sP * cY),
              a.x *    cP  * sY + a.y * (  cR * cY + sR * sP * sY) + a.z * (- sR * cY + cR * sP * sY),
              a.x * (- sP)      + a.y * (  sR * cP               ) + a.z * (  cR * cP               )
	      );

}

#endif
