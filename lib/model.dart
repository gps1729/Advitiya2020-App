class EventModel {
  int id;
  String name;
  String venue;
  String dateTime;
  String avatarUrl;
  int teamLowerLimit;
  int teamUpperLimit;
  int fee;
  String prize;
  Map manager;
  String rulebook;

  EventModel(
      this.id,
      this.name,
      this.venue,
      this.dateTime,
      this.avatarUrl,
      this.teamLowerLimit,
      this.teamUpperLimit,
      this.fee,
      this.prize,
      this.manager,
      this.rulebook);

  EventModel.fromJson(Map json) {
    this.id = json['id'];
    this.name = json['name'];
    this.venue = json['venue'];
    this.dateTime = json['start_date_time'];
    this.avatarUrl = json['image'];
    this.teamLowerLimit = json['team_lower_limit'];
    this.teamUpperLimit = json['team_upper_limit'];
    this.fee = json['fees'];
    this.prize = json['prize'];
    this.manager = json['coordinator'];
    this.rulebook = json['rulebook'];
  }
}
