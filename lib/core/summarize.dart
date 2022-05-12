String summarize(String s) {
  // get first 50 chars, truncate at period
  if (s.length > 50) {
    return s.substring(0, 50) + "...";
  } else {
    return s;
  }
}
