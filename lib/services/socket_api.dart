import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketApi {
  // A static private instance to access _socketApi from inside class only
  static final SocketApi _socketApi = SocketApi._internal();

  // An internal private constructor to access it for only once for static instance of class.
  SocketApi._internal();

  // Factry constructor to retutn same static instance everytime you create any object.
  factory SocketApi() {
    return _socketApi;
  }

  // All socket related functions.
  IO.Socket getInstance() {
    IO.Socket socket = IO.io(
        '${dotenv.env['SOCKET_URL']}',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());
    return socket;
  }
}
