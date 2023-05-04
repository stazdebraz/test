import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 1)));
        await remoteConfig.fetchAndActivate();
        var temp = remoteConfig.getString('url');
        return temp;
  }
}
