class LoginModel {
  String? status;
  Data? data;

  LoginModel({this.status, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? tokenType;
  String? accessToken;
  String? refreshToken;
  String? expiresIn;
  String? operatorUid;
  String? operatorName;
  int? userId;
  int? deviceId;
  bool? isMulticastNetwork;
  bool? isBlocked;
  List<dynamic>? subscriberTags;

  Data(
      {this.tokenType,
      this.accessToken,
      this.refreshToken,
      this.expiresIn,
      this.operatorUid,
      this.operatorName,
      this.userId,
      this.deviceId,
      this.isMulticastNetwork,
      this.isBlocked,
      this.subscriberTags});

  Data.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    operatorUid = json['operator_uid'];
    operatorName = json['operator_name'];
    userId = json['user_id'] != null
        ? int.tryParse(json['user_id'].toString())
        : null;
    deviceId = json['device_id'] != null
        ? int.tryParse(json['device_id'].toString())
        : null;
    isMulticastNetwork = json['is_multicast_network'];
    isBlocked = json['is_blocked'];
    subscriberTags = json['subscriber_tags'] != null
        ? List<dynamic>.from(json['subscriber_tags'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokenType'] = tokenType;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['expiresIn'] = expiresIn;
    data['operatorUid'] = operatorUid;
    data['operatorName'] = operatorName;
    data['userId'] = userId;
    data['deviceId'] = deviceId;
    data['isMulticastNetwork'] = isMulticastNetwork;
    data['isBlocked'] = isBlocked;
    if (subscriberTags != null) {
      data['subscriberTags'] =
          subscriberTags!.map((e) => e.toString()).toList();
    }
    return data;
  }
}
