abstract class PostEvent{}

class Fetch extends PostEvent {
  @override
  String toString() => 'Fetch';
}
