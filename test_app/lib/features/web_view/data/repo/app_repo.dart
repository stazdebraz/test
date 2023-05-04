import '../../../../core/services/firebase_remote_config.dart';

class AppRepo {
  getData() async {
    try {
      final String serverData =
          await FirebaseRemoteConfigService().initConfig();
      return serverData;
    } catch (e) {
      return 'error';
    }
  }
}
