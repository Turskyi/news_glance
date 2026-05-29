String formatTimeAgo(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);
  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  }
  return 'Just now';
}
