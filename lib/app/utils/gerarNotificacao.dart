import 'package:cuidaagente/app/utils/notificationAwesomeNotification.dart';

class NotificacoesGerais {
  static Future<void> criarNotificacaoAgendado(
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

    // Garantindo valores padrão para os campos que não podem ser nulos
    int notificationId = id ?? DateTime.now().millisecondsSinceEpoch;
    String notificationTitle = descricao ?? "N O V A D E M A N D A";
    String notificationBody = Body ?? "";
    Map<String, String> notificationPayload = payload ?? {'id': notificationId.toString()};

    CustomNotification notificationBeforeEnd = CustomNotification(
      id: notificationId,
      title: notificationTitle,
      body: notificationBody,
      payload: notificationPayload,
    );

    try {
      // Schedule notification
      await NotificationAwesomeNotification.showImmediateNotification(
        id: notificationBeforeEnd.id,
        title: notificationBeforeEnd.title,
        body: notificationBeforeEnd.body,
        payload: notificationBeforeEnd.payload,
        summary: "Nova demanda",
      );
    } catch (e) {
      print("Erro ao criar notificação: $e");
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
