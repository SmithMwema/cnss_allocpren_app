import 'package:get/get.dart';
import '../modèle/notification.dart';
import '../service/auth_service.dart';
import '../service/firestore_service.dart';

class NotificationCtrl extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = true.obs;
  // --- ON UTILISE LE BON NOM DE CLASSE : AppNotification ---
  final RxList<AppNotification> notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    chargerNotifications();
  }

  Future<void> chargerNotifications() async {
    if (_authService.user == null) return;
    try {
      isLoading.value = true;
      final notifs = await _firestore.recupererNotifications(_authService.user!.uid);
      notifications.assignAll(notifs);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> marquerCommeLue(String notificationId) async {
    await _firestore.marquerNotificationCommeLue(notificationId);
    chargerNotifications();
  }
}