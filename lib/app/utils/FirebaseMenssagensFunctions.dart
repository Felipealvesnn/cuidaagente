import 'package:cuidaagente/app/firebase_options.dart';
import 'package:cuidaagente/app/utils/gerarNotificacao.dart';
import 'package:cuidaagente/app/utils/notificationAwesomeNotification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Mensagem recebida: ${message.data}");
  try {
    if (message.data.containsKey('id') &&
        message.data['id'] != null &&
        message.data['id'] != '') {
      await NotificacoesGerais.criarNotificacaoNow(int.parse(message.data['id']),
          message.notification?.body, message.notification?.title);
    } else {
      print("ID não encontrado ou vazio. Não será criada uma notificação.");
    }
  } catch (e) {
    print(e);
  }
}

iniciarFirebasemsg() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationAwesomeNotification.initializeNotification();
  //await FirebaseMessaging.instance.subscribeToTopic('todos_usuarios');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
}
