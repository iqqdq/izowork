class TaskState {
  TaskState({
    required this.states,
  });

  List<String> states;

  factory TaskState.fromJson(Map<String, dynamic> json) => TaskState(
        states: List<String>.from(json["states"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "states": List<dynamic>.from(states.map((x) => x)),
      };
}
