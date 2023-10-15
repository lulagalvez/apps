class User {
  final String username;
  final String password;
  final String fullName;

  User(this.username, this.password, this.fullName);
}

class UserRepository {
  final Map<String, User> _users = {
    'usuario1': User('usuario1', 'password1', 'Nombre'),
    // Agrega más usuarios según sea necesario
  };

  bool authenticateUser(String username, String password) {
    User? user = _users[username];
    return user != null && user.password == password;
  }

  bool isUsernameTaken(String username) {
    return _users.containsKey(username);
  }

  String? getFullNameByCredentials(String username, String password) {
    User? user = _users[username];
    if (user != null && user.password == password) {
      return user.fullName; // Devuelve el nombre real del usuario registrado
    }
    return null; // Devuelve null si las credenciales no son válidas
  }

  void registerUser(String username, String password, String fullName) {
    _users[username] = User(username, password, fullName);
  }

  // Singleton implementation
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();
}
