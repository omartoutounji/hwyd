class Note {
  String name;
  String text;

  Note(this.name, this.text);

  factory Note.fromJson(Map<String, dynamic> parsedJson){
    return Note(
      parsedJson['name'],
      parsedJson['text'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'text': text,
  };
}