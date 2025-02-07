import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationAwesomeNotification {
  /// 🔹 **Configurações Globais**
  static const String _channelKey = 'high_importance_channel';
  static const String _channelName = 'Notificações Importantes';
  static const String _channelDescription = 'Canal de notificações críticas';
  static const String _soundPath = 'resource://raw/res_alarm';
  static const String _groupKey = 'high_importance_channel_group';

  /// 🔹 **Inicializa o sistema de notificações**
  static Future<void> initializeNotification() async {
    // Deletar o canal se já existir para garantir que as configurações sejam aplicadas corretamente
    await AwesomeNotifications().removeChannel(_channelKey);

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: _groupKey,
          channelKey: _channelKey,
          channelName: _channelName,
          channelDescription: _channelDescription,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: false,
          playSound: true,
          criticalAlerts: true,
          enableVibration: true,
          soundSource: _soundPath,
         // defaultRingtoneType: DefaultRingtoneType.Alarm,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: _groupKey,
          channelGroupName: 'Grupo de Notificações Críticas',
        )
      ],
      debug: true,
    );

    await _requestPermissions();
    _setListeners();
  }

  /// 🔹 **Solicita permissões para tocar som personalizado**
  static Future<void> _requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        channelKey: _channelKey,
        permissions: [
          NotificationPermission.Sound,
          NotificationPermission.CriticalAlert,
        ],
      );
    }
  }

  /// 🔹 **Define os listeners para ações de notificações**
  static void _setListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onDismissActionReceived,
    );
  }

  /// 🔹 **Quando uma nova notificação é criada**
  static Future<void> _onNotificationCreated(
      ReceivedNotification receivedNotification) async {
    debugPrint('✅ Notificação Criada: ${receivedNotification.id}');
  }

  /// 🔹 **Quando a notificação é exibida**
  static Future<void> _onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    debugPrint('🔔 Notificação Recebida e Exibida');
  }

  /// 🔹 **Quando o usuário descarta a notificação**
  static Future<void> _onDismissActionReceived(
      ReceivedAction receivedAction) async {
    debugPrint('❌ Notificação Descartada');
  }

  /// 🔹 **Quando o usuário interage com a notificação**
  static Future<void> _onActionReceived(ReceivedAction receivedAction) async {
    debugPrint('📲 Notificação Clicada');

    await Get.offAllNamed(Routes.HOME);

    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      debugPrint('🚀 Navegando para HOME');
    }
  }

  /// 🔹 **Envia uma notificação com suporte a agendamento**
  /// 🔹 **Envia uma notificação (Instantânea ou Agendada)**
  static Future<void> showNotification({
    required String title,
    required String body,
    int? id,
    String? summary,
    Map<String, String>? payload,
    ActionType actionType = ActionType.Default,
    NotificationLayout notificationLayout = NotificationLayout.Default,
    NotificationCategory? category,
    String? bigPicture,
    List<NotificationActionButton>? actionButtons,
    bool scheduled = false,
    int? interval, // Apenas necessário se for agendada
  }) async {
    try {
      assert(!scheduled || (scheduled && interval != null));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id ?? DateTime.now().millisecondsSinceEpoch,
          channelKey: _channelKey,
          title: title,
          body: body,
          locked: true,
          wakeUpScreen: true,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: NotificationCategory.Alarm,
          payload: payload,
          customSound: _soundPath,
          bigPicture: bigPicture,
        ),
        actionButtons: actionButtons ??
            [
              NotificationActionButton(
                key: 'stop_alarm',
                label: 'Visto',
                actionType: ActionType.DismissAction,
              )
            ],
        schedule: scheduled
            ? NotificationInterval(
                interval: Duration(minutes: interval!),
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true,
              )
            : null,
      );
    } catch (e) {
      debugPrint('❌ Erro ao enviar notificação: $e');
    }
  }
}
