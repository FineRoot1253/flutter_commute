enum UserState{
  waiting_request,
  network_required,
  register_required,
  certificated_beforeWork,
  certificated_onWork,
  certificated_workOnOutside,
}

extension ParseToString on UserState{
  String toShortString() => this.toString().split('.').last;
}

extension StringToUserState on UserState{


}