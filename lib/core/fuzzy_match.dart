import 'dart:ffi';

import 'dart:math';

bool match(String s1, String s2) {
  var dist = cosineDistance(s1, s2);
  return dist >= 0.6;
}

double cosineDistance(String s1, String s2) {
  // create list of all unique letters in s1 and s2
  String concat = s1 + s2;
  List<String> letters = [];
  for (int i = 0; i < concat.length; i++) {
    if (!letters.contains(concat[i])) {
      letters.add(concat[i]);
    }
  }

  // create two vectors for s1 and s2 determining occurence of character
  List<double> vector1 = [];
  List<double> vector2 = [];
  for (int i = 0; i < letters.length; ++i) {
    if (s1.contains(letters[i])) {
      vector1.add(1);
    } else {
      vector1.add(0);
    }

    if (s2.contains(letters[i])) {
      vector2.add(1);
    } else {
      vector2.add(0);
    }
  }

  //calculate dot product of vector1 and vector2
  double dotProduct = 0;
  for (int i = 0; i < vector1.length; ++i) {
    dotProduct += vector1[i] * vector2[i];
  }

  // get sqrt of sum of squares of vector1
  double vector1Sqrt = 0;
  double vector2Sqrt = 0;
  for (int i = 0; i < vector1.length; ++i) {
    vector1Sqrt += vector1[i] * vector1[i];
    vector2Sqrt += vector2[i] * vector2[i];
  }
  vector1Sqrt = sqrt(vector1Sqrt);
  vector2Sqrt = sqrt(vector2Sqrt);

  // calculate cosine distance
  double cosineDistance = dotProduct / (vector1Sqrt * vector2Sqrt);
  return cosineDistance;
}
