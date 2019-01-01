// To parse this JSON data, do
//
//     final configuration = configurationFromJson(jsonString);

import 'dart:convert';

Configuration configurationFromJson(String str) {
  final jsonData = json.decode(str);
  return Configuration.fromJson(jsonData);
}

String configurationToJson(Configuration data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Configuration {
  Images images;
  List<String> changeKeys;

  Configuration({
    this.images,
    this.changeKeys,
  });

  factory Configuration.fromJson(Map<String, dynamic> json) => new Configuration(
    images: Images.fromJson(json["images"]),
    changeKeys: new List<String>.from(json["change_keys"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "images": images.toJson(),
    "change_keys": new List<dynamic>.from(changeKeys.map((x) => x)),
  };
}

class Images {
  String baseUrl;
  String secureBaseUrl;
  List<String> backdropSizes;
  List<String> logoSizes;
  List<String> posterSizes;
  List<String> profileSizes;
  List<String> stillSizes;

  Images({
    this.baseUrl,
    this.secureBaseUrl,
    this.backdropSizes,
    this.logoSizes,
    this.posterSizes,
    this.profileSizes,
    this.stillSizes,
  });

  factory Images.fromJson(Map<String, dynamic> json) => new Images(
    baseUrl: json["base_url"],
    secureBaseUrl: json["secure_base_url"],
    backdropSizes: new List<String>.from(json["backdrop_sizes"].map((x) => x)),
    logoSizes: new List<String>.from(json["logo_sizes"].map((x) => x)),
    posterSizes: new List<String>.from(json["poster_sizes"].map((x) => x)),
    profileSizes: new List<String>.from(json["profile_sizes"].map((x) => x)),
    stillSizes: new List<String>.from(json["still_sizes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "base_url": baseUrl,
    "secure_base_url": secureBaseUrl,
    "backdrop_sizes": new List<dynamic>.from(backdropSizes.map((x) => x)),
    "logo_sizes": new List<dynamic>.from(logoSizes.map((x) => x)),
    "poster_sizes": new List<dynamic>.from(posterSizes.map((x) => x)),
    "profile_sizes": new List<dynamic>.from(profileSizes.map((x) => x)),
    "still_sizes": new List<dynamic>.from(stillSizes.map((x) => x)),
  };
}