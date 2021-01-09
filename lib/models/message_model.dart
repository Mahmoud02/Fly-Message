class Message {
  String _message;
  int _numOfLike;
  String _documentId;

  String get message => _message;

  int get numOfLike => _numOfLike;

  set numOfLike(int value) {
    _numOfLike = value;
  }

  String get documentId => _documentId;

  Message(this._message, this._numOfLike, this._documentId);

  @override
  String toString() {
    return 'Message{message: $_message, numOfLike: $_numOfLike}';
  }
}
