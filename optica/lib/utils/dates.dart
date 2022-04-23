String tempsRestant(DateTime date) {
  final diff = date.difference(DateTime.now());
  if (diff.inDays > 1) {
    return "Queden ${diff.inDays} dies";
  }
  if (diff.inHours > 0) {
    return "Queden ${diff.inHours} hores";
  }
  if (diff.inMinutes > 0) {
    return "Queden ${diff.inMinutes} minuts";
  }
  return "Ha vençut";
}
