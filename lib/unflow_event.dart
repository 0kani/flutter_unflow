class UnflowEvent {
  final String id;
  final String name;
  final int occurredAt;
  final int? screenId;
  final int? rating;

  UnflowEvent({
    required this.id,
    required this.name,
    required this.occurredAt,
    this.screenId,
    this.rating,
  });

  UnflowEvent.fromJson(Map<dynamic, dynamic> data)
      : id = data['id'],
        name = data['name'],
        occurredAt = data['occurred_at'],
        screenId = data['screen_id'],
        rating = data['rating'];
}
