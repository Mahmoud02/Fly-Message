enum AuthenticationResponseState { Success, Failed, loading, Intial }

class AuthenticationResponse {
  AuthenticationResponseState authenticationResponseState;
  String msg;

  AuthenticationResponse(this.authenticationResponseState, this.msg);
}
