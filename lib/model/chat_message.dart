class ChatMessage {
  ChatMessage({
    required this.message,
    required this.role,
  });

  String message;
  Role role;
}

enum Role {
  SYSTEM('system'),
  USER('user'),
  ASSISTANT('assistant'),
  ;

  const Role(this.name);

  final String name;
}
