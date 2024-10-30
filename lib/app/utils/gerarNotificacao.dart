import 'package:cuidaagente/app/utils/notificationAwesomeNotification.dart';

class NotificacoesGerais {
  static Future<void> criarNotificacaoAgendado(int? id, String? Body, String? descricao,
      [Map<String, String>? payload]) async {
    int alerta = 0;

    CustomNotification notificationBeforeEnd = CustomNotification(
      id: id ?? DateTime.now().millisecondsSinceEpoch,
      title: descricao ?? "N O V A D E M A N D A",
      body: Body ?? "",
      payload: payload ?? {},
    );

    try {
      // Schedule notification for when parking is almost ending.
      await NotificationAwesomeNotification.showNotification(
        id: notificationBeforeEnd.id,
        title: notificationBeforeEnd.title,
        body: notificationBeforeEnd.body,
        payload: notificationBeforeEnd.payload,
        interval: 5,
        scheduled: true,
      );

      // Schedule notification for when parking time is up.
    } catch (e) {
      print(e);
    }
  }

  static Future<void> criarNotificacaoNow(
      int? id, String? Body, String? descricao,
      [Map<String, String>? payload]) async {
    int alerta = 0;

    CustomNotification notificationBeforeEnd = CustomNotification(
      id: id ?? DateTime.now().millisecondsSinceEpoch,
      title: descricao ?? "N O V A D E M A N D A",
      body: Body ?? "",
      payload: payload ?? {},
    );

    try {
      // Schedule notification for when parking is almost ending.
      await NotificationAwesomeNotification.showImmediateNotification(
        id: notificationBeforeEnd.id,
        title: notificationBeforeEnd.title,
        body: notificationBeforeEnd.body,
        payload: notificationBeforeEnd.payload,
      );

      // Schedule notification for when parking time is up.
    } catch (e) {
      print(e);
    }
  }

}

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final Map<String, String> payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
