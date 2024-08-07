Map<String, dynamic> parseDataString(String dataString) {
  Map<String, dynamic> dataMap = {};
  dataString = dataString.replaceAll('{', '').replaceAll('}', '');
  RegExp regExp = RegExp(r'([^,:\s]+)\s*:\s*([^,]*)');
  Iterable<Match> matches = regExp.allMatches(dataString);

  for (Match match in matches) {
    String key = match.group(1)?.trim() ?? '';
    String value = match.group(2)?.trim() ?? '';
    dataMap[key] = parseValue(value);
  }

  return dataMap;
}

dynamic parseValue(String value) {
  if (value == 'null') {
    return null;
  } else if (value == 'true' || value == 'false') {
    return value == 'true';
  } else if (value.startsWith('"') && value.endsWith('"')) {
    return value.substring(1, value.length - 1);
  } else {
    return int.tryParse(value) ?? double.tryParse(value) ?? value;
  }
}
