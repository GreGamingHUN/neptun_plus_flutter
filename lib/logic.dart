String trimString(String input, int length) {
  return (input.length > length ? "${input.substring(0, length)}..." : input);
}

String trimCSSfromMessage(String message) {
  const String cssPostfix = "\t\t\r\n\t\r\n\t\r\n\t\t";
  if (message.contains(cssPostfix)) {
    return message.substring(message.lastIndexOf(cssPostfix) + 12);
  }
  return message;
}
