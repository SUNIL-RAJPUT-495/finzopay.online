import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({super.key});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  final RxBool _isLoading = true.obs;
  final RxDouble _loadingProgress = 0.0.obs;

  String? paymentUrl;
  String? orderId;

  @override
  void initState() {
    super.initState();

    // Get arguments passed from navigation
    final args = Get.arguments as Map<String, dynamic>?;
    paymentUrl = args?['paymentUrl'] as String?;
    orderId = args?['orderId'] as String?;

    debugPrint('🔷 PaymentWebViewPage initialized');
    debugPrint('🔷 Payment URL: $paymentUrl');
    debugPrint('🔷 Order ID: $orderId');

    if (paymentUrl == null || paymentUrl!.isEmpty) {
      debugPrint('❌ No payment URL provided');
      Get.back();
      Get.snackbar('Error', 'Invalid payment URL');
      return;
    }

    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _loadingProgress.value = progress / 100;
            debugPrint('📊 Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            _isLoading.value = true;
            debugPrint('🌐 Page started loading: $url');
          },
          onPageFinished: (String url) {
            _isLoading.value = false;
            debugPrint('✅ Page finished loading: $url');

            // Check if the URL is the payment return URL
            if (url.contains('finzopay.online/payment-return')) {
              debugPrint(
                '🔔 Payment return page detected, closing in 5 seconds...',
              );

              // Close the WebView after 5 seconds
              Future.delayed(const Duration(milliseconds: 2500), () {
                if (mounted) {
                  debugPrint('✅ Closing payment WebView');
                  Get.back(result: true);
                }
              });
            }
          },
          onUrlChange: (UrlChange changeUrl) {
            /* final url = changeUrl.url ?? 'null';
            debugPrint('🔄 URL changed to: $url');

            // Check for payment success/failure patterns
            if (url.contains('success') || url.contains('payment-success')) {
              debugPrint('✅ Payment success detected in URL');
              _handlePaymentSuccess();
            } else if (url.contains('failed') ||
                url.contains('payment-failed') ||
                url.contains('cancel')) {
              debugPrint('❌ Payment failure detected in URL');
              _handlePaymentFailure();
            }
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('❌ HTTP Error: ${error.response?.statusCode}');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('❌ Web Resource Error: ${error.description}');
            debugPrint('   Error Code: ${error.errorCode}');
            debugPrint('   Error Type: ${error.errorType}');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('🔗 Navigation request: ${request.url}');

            // Allow all navigation for payment flow
            return NavigationDecision.navigate;*/
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              debugPrint('🔄 Refreshing payment page');
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 156719092
          // 156719694
          WebViewWidget(controller: _controller),

          // Loading indicator
          Obx(() {
            if (_isLoading.value) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading payment page...',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          '${(_loadingProgress.value * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🔷 PaymentWebViewPage disposed');
    super.dispose();
  }
}
