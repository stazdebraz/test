import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/services/service_locator.dart';
import '../../../game/app_game.dart';
import '../bloc/app_bloc.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({super.key});

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final SharedPreferences prefs;
  late final WebViewController _controller;
  String serverData = '';
  String url = '';
  final _bloc = sl<AppBloc>();

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final String link = prefs.getString('link') ?? '';
    if (link == '') {
      _bloc.add(GetConfigEvent());
    } else {
      _bloc.add(GetSavedConfigEvent(localData: link));
    }
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final String? current = await _controller.currentUrl();
        if (current != serverData) {
          _controller.goBack();
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocProvider.value(
            value: _bloc,
            child: BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {
                if (state is MockState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppGame(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ErrorState) {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                            'A network connection is required to continue'),
                        ElevatedButton(
                          onPressed: () {
                            _bloc.add(GetConfigEvent());
                          },
                          child: const Text('Reload'),
                        )
                      ],
                    ),
                  );
                }
                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SuccessState) {
                  serverData = state.response;
                  url = state.response;
                  prefs.setString('link', state.response);
                  _controller = WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..setBackgroundColor(const Color(0x00000000))
                    ..setNavigationDelegate(
                      NavigationDelegate(
                        onUrlChange: (UrlChange change) async {
                          bool result =
                              await InternetConnectionChecker().hasConnection;
                          if (result == true) {
                            url = change.url!;
                            log(change.url!);
                          }
                        },
                      ),
                    )
                    ..loadRequest(Uri.parse(url));
                  return WebViewWidget(controller: _controller);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
