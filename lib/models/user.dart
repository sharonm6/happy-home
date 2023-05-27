class User {
  final String uid;
  String name;
  String email;
  bool hasCar;
  bool isDarkMode;
  bool cookiesSaved;
  bool localStorageSaved;
  bool geolocationEnabled;
  bool isVegetarian;
  bool isVegan;

  User(
      {required this.uid,
      this.name = '',
      this.email = '',
      this.hasCar = false,
      this.isDarkMode = false,
      this.cookiesSaved = true,
      this.localStorageSaved = true,
      this.geolocationEnabled = true,
      this.isVegetarian = false,
      this.isVegan = false});

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'] ?? '',
        email = data['email'] ?? '',
        hasCar = data['hasCar'] ?? false,
        isDarkMode = data['isDarkMode'] ?? false,
        cookiesSaved = data['cookiesSaved'] ?? true,
        localStorageSaved = data['localStorageSaved'] ?? true,
        geolocationEnabled = data['geolocationEnabled'] ?? true,
        isVegetarian = data['isVegetarian'] ?? false,
        isVegan = data['isVegan'] ?? false
        ;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'hasCar': hasCar,
      'isDarkMode' : isDarkMode,
      'cookiesSaved' : cookiesSaved,
      'localStorageSaved' : localStorageSaved,
      'geolocationEnabled' : geolocationEnabled,
      'isVegetarian' : isVegetarian,
      'isVegan' : isVegan
    };
  }
}
