class Success{
  int code;
  String message;
  Map<String , dynamic> response;
  Success({ required this.code , required this.message , required this.response});
}

class Failure{
  int code;
  String errorResponse;
  Failure({ required this.code , required this.errorResponse});
}