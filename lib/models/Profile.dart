import 'package:greet_app/models/Gift.dart';

class Profile {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? dateOfBirth;
  final double? balance;
  final bool? isFollowing;
  final List<Profile>? followers;
  final List<Profile>? followings;
  final List<Gift>? gifts;

  const Profile(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.avatar,
      this.dateOfBirth,
      this.isFollowing,
      this.followers,
      this.followings,
      this.balance,
      this.gifts});

  factory Profile.fromJson(Map<String, dynamic> json) {
    List<Profile> followers = json['followers'] != null
        ? List<Profile>.from(json['followers'].map((x) => Profile.fromJson(x)))
        : [];
    List<Profile> followings = json['followings'] != null
        ? List<Profile>.from(json['followings'].map((x) => Profile.fromJson(x)))
        : [];
    List<Gift> gifts = json['gifts'] != null
        ? List<Gift>.from(json['gifts'].map((x) => Gift.fromJson(x)))
        : [];
    return Profile(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        avatar: json['avatar'],
        dateOfBirth: json['date_of_birth'],
        isFollowing: json['isFollowing'],
        balance: json['balance'].toDouble(),
        gifts: gifts,
        followers: followers,
        followings: followings);
  }

  @override
  String toString() {
    return username ?? "";
  }
}
