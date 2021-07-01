class Message {
  String datetime;
  String uid;
  String content;
  bool isMe;

  Message({this.datetime, this.uid, this.content, this.isMe});

  Message.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    uid = json['uid'];
    content = json['content'];
    isMe = json['isMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['uid'] = this.uid;
    data['content'] = this.content;
    data['isMe'] = this.isMe;
    return data;
  }
}