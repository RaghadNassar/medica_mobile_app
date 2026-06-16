// import 'package:dart_pusher_channels/dart_pusher_channels.dart';
// import 'package:get/get.dart';
// import 'package:raghad_pro/core/api/end_point.dart';

// class RealTimeService extends GetxService {
//   late PusherChannelsClient client;

//   final String hostSocket  = EndPoint.host;
//   final int port = 8080;
//   final String key = 't67s8r9t143jhwnz140u';

//   Future<RealTimeService> init() async {
//     _createAndConnect();

//     Future.delayed(const Duration(seconds: 2), () {
//       print("ℹ️ RealTimeService: connect() called -> ws://$hostSocket:$port (key=$key)");
//     });

//     return this;
//   }

//   void _createAndConnect() {
//     client = PusherChannelsClient.websocket(
//       options: PusherChannelsOptions.fromHost(
//         host: hostSocket,
//         port: port,
//         scheme: 'ws', // Flutter يحتاج ws أو wss
//         key: key,
//       ),
//       connectionErrorHandler: (exception, trace, client) {
//         print("❌ RealTimeService connection error: $exception");
//         print(trace);
//       },
//     );

//     print("ℹ️ RealTimeService: calling client.connect()");
//     client.connect();

//     // محاولة التقاط أخطاء إضافية إن توفّرت في الكائن (dynamic guard)
//     try {
//       final dyn = client as dynamic;
//       if (dyn.onConnectionError != null) {
//         dyn.onConnectionError.listen((e) {
//           print("❌ onConnectionError stream: $e");
//         });
//       }
//     } catch (_) {}
//   }

//   dynamic publicChannel(String name) {
//     print("ℹ️ RealTimeService: publicChannel requested -> $name");
//     try {
//       final ch = client.publicChannel(name);
//       print("ℹ️ RealTimeService: publicChannel returned -> ${ch.runtimeType}");
//       return ch;
//     } catch (e, st) {
//       print("❌ RealTimeService.publicChannel error: $e");
//       print(st);
//       rethrow;
//     }
//   }


  

//   Future<void> reconnect() async {
//     print("ℹ️ RealTimeService: reconnect requested");
//     try {
//       await (client as dynamic).disconnect();
//     } catch (e) {
//       print("⚠️ disconnect error (ignored): $e");
//     }
//     _createAndConnect();
//   }
// }
