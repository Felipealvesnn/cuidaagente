import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cuidaagente/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../main.dart';

class NotificationAwesomeNotification {
  static Future<void> initializeNotification() async {
    var certo = await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: false,
          playSound: false,
          criticalAlerts: true,
          enableVibration: true,
          // soundSource: 'resource://raw/alerta', // Referência ao som no Android
          // locked: false,
          // defaultRingtoneType: DefaultRingtoneType.Alarm,
          //  soundSource: 'assets/alarm.mp3',
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Nova notificacao criada');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    await playerMain.setLoopMode(LoopMode.one);
    await playerMain.seek(Duration.zero);

    await playerMain.play();

    debugPrint(' notitifacao recebida no alô');
    //await Get.find<HomeController>().gerarNotificacao();
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // await Get.find<HomeController>().EviarMsglidaById(receivedAction.id!);
    await playerMain.stop();
     await playerMain.setLoopMode(LoopMode.off);
    debugPrint('notifação descartada');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');

    await playerMain.stop();
     await playerMain.setLoopMode(LoopMode.off);
    await Get.offAllNamed(Routes.HOME);

    // await playerMain.stop();
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      //  HomeView.navigatorKey!.currentState?.push(
      //     MaterialPageRoute(
      //       builder: (context) => HomeView(),
      //     ),
      //   );
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final int? id,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id ?? DateTime.now().millisecondsSinceEpoch,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        locked: true,
        // customSound:
        //     'assets/alarm.mp3', // Adicione o caminho do arquivo de som aqui
        wakeUpScreen: true,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload, //payload,
        // bigPicture: 'assets/flutter.png',
      ),
      actionButtons: actionButtons ??
          [
            NotificationActionButton(
                key: 'stop_alarm',
                label: 'Visto',
                actionType: ActionType.DismissAction)
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
  }

  static Future<void> showImmediateNotification({
    required final String title,
    required final String body,
    final int? id,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
  }) async {
    try {
      var msg = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id ?? DateTime.now().millisecondsSinceEpoch,
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          locked: true,
          wakeUpScreen: true,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: category,
          payload: payload,
          bigPicture: bigPicture,
          //customSound: 'assets/alarm.mp3',
        ),
        actionButtons: actionButtons ??
            [
              NotificationActionButton(
                key: 'stop_alarm',
                label: 'Visto',
                actionType: ActionType.DismissAction,
              )
            ],
      );
    } on Exception catch (e) {
      print(e);

      // TODO
    }
  }
}
