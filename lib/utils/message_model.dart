class MessageModel{
  String message;
  String date;

  MessageModel({required this.message, required this.date});

  //setters and getter
  String get getMessage => message;
  String get getDate => date;

  set setMessage(String message) => this.message = message;
  set setDate(String date) => this.date = date;
}