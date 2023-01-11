class ChatModel {
  String txt;
  ChatEnum chatEnum;
  ChatModel({required this.txt, required this.chatEnum});
}

enum ChatEnum { user, bot }
