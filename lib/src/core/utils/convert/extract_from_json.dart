String extractAvatarFromJson(String? data) {
  if (data == null ||
      data.isEmpty ||
      !data.startsWith('http') ||
      !RegExp(
        r'\.(jpg|jpeg|png|gif|bmp|webp|svg)$',
        caseSensitive: false,
      ).hasMatch(data)) {
    return 'https://www.gravatar.com/avatar';
  }

  return data;
}
