import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:rp_app/controllers/buy_rp_controller.dart';
import 'package:rp_app/services/rp_service.dart';

class BuyUpiDetails extends StatefulWidget {
  const BuyUpiDetails({super.key});

  @override
  State<BuyUpiDetails> createState() => _BuyUpiDetailsState();
}

class _BuyUpiDetailsState extends State<BuyUpiDetails> {
  final BuyRPController controller = Get.find<BuyRPController>();
  final RPService _rpService = RPService();
  final TextEditingController _paymentIdController = TextEditingController();

  bool _isLoading = true;
  String? _upiId;
  String? _qrImage;
  String? _errorMessage;
  bool _isDownloadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadUpiDetails();
  }

  Future<void> _downloadAndOpenQR() async {
    if (_qrImage == null || _qrImage!.isEmpty) {
      Get.snackbar("Error", "Invalid QR image URL");
      return;
    }

    setState(() => _isDownloadingImage = true);

    try {
      final response = await http.get(Uri.parse(_qrImage!));

      if (response.statusCode != 200) {
        throw Exception("Failed to download image");
      }

      final bytes = response.bodyBytes;

      // Save locally (temp)
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/upi_qr_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = await File(filePath).create();
      await file.writeAsBytes(bytes); // ✅ non-blocking

      // Open file
      await OpenFilex.open(file.path);

      Get.snackbar(
        "Success",
        "QR Code saved to gallery",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Download Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloadingImage = false);
      }
    }
  }

  Future<void> _loadUpiDetails() async {
    try {
      final res = await _rpService.getUpiDetails();
      if (res['upiId'] != null && res['qrImage'] != null) {
        setState(() {
          _upiId = res['upiId'];
          _qrImage = res['qrImage'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Invalid UPI details received";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      "Copied",
      "UPI ID copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amountText = controller.amountController.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        title: const Text(
          "Payment Details",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Scan QR to Pay",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_qrImage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _qrImage!,
                          height: 220,
                          width: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _isDownloadingImage
                          ? null
                          : _downloadAndOpenQR,
                      icon: _isDownloadingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.download,
                              color: Color(0xFF6A11CB),
                            ),
                      label: Text(
                        _isDownloadingImage
                            ? "Downloading..."
                            : "Download QR Code",
                        style: const TextStyle(
                          color: Color(0xFF6A11CB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF6A11CB,
                        ).withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6A11CB).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "UPI ID",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _upiId ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard(_upiId ?? ""),
                          icon: const Icon(
                            Icons.copy,
                            color: Color(0xFF6A11CB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Please pay ₹$amountText to the above UPI ID or QR code, then enter the Transaction/UTR ID below.",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _paymentIdController,
                    keyboardType: TextInputType.number,
                    maxLength: 12,

                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: "",
                      labelText: "UTR Number",
                      hintText: "Enter 12-digit UTR No.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF6A11CB),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(() {
                    final isPaying = controller.isPaying.value;
                    return Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF9F7AEA)],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A11CB).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: isPaying
                            ? null
                            : () {
                                final uId = _paymentIdController.text.trim();
                                if (uId.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please enter Transaction ID",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                controller.submitManualPayment(uId);
                              },
                        child: isPaying
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Submit Request",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
