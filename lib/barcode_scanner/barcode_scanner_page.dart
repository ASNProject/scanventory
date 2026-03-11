// Copyright 2026 ariefsetyonugroho
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:satset/widgets/widgets.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController();

  List<dynamic>? items;

  bool isLoading = false;
  String? lastScannedBarcode;
  bool isFetching = false;

  Future<void> fetchData(String barcode) async {
    setState(() => isLoading = true);

    final url = Uri.parse(
      "https://script.google.com/macros/s/AKfycbz9MgpNYedjkBJt2BHPbCcUQoutAAzxqd0SCBy4BEnkH8H8fnEowvLT7sr9kpOhSo0D/exec?barcode=$barcode&t=${DateTime.now().millisecondsSinceEpoch}",
    );

    final response = await http.get(
      url,
      headers: {
        "Cache-Control": "no-cache",
        "Pragma": "no-cache",
      },
    );
    final data = jsonDecode(response.body);

    setState(() {
      if (data is List) {
        items = data;
      } else {
        items = null;
      }
      isLoading = false;
    });
  }

  void resetData() {
    setState(() {
      items = null;
      lastScannedBarcode = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.first.rawValue;

              if (barcode != null && !isFetching) {
                isFetching = true;
                lastScannedBarcode = barcode;

                fetchData(barcode).then((_) {
                  Future.delayed(const Duration(seconds: 2), () {
                    isFetching = false;
                  });
                });
              }
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white70,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Arahkan barcode ke kamera",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SATSET',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Scan Sekali Aset Terkendali",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : items == null || items!.isEmpty
                              ? ListView(
                                  controller: scrollController,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info_outline_rounded,
                                            color: Colors.grey,
                                            size: 40,
                                          ),
                                          Text(
                                            "Belum ada data",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            "Pastikan barcode sudah benar dan terdaftar di sistem",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: items!.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Data ABT 2025",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: resetData,
                                              child: Text(
                                                "Reset",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    final item = items![index - 1];

                                    return Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            RowText(
                                              leftText: "NUP",
                                              rightText:
                                                  item['nup']?.toString() ??
                                                      '-',
                                              title: true,
                                            ),
                                            const SizedBox(height: 10),
                                            RowText(
                                              leftText: "Kode Barang",
                                              rightText: item['kode_barang']
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                            RowText(
                                              leftText: "Jenis BMN",
                                              rightText: item['jenis_bmn']
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                            RowText(
                                              leftText: "Jenis Perangkat",
                                              rightText: item['jenis_perangkat']
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                            RowText(
                                              leftText: "Merk/Type",
                                              rightText: item['merk_type']
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                            RowText(
                                              leftText: "Lokasi",
                                              rightText:
                                                  item['lokasi']?.toString() ??
                                                      '-',
                                            ),
                                            RowText(
                                              leftText: "User",
                                              rightText:
                                                  item['user']?.toString() ??
                                                      '-',
                                            ),
                                            RowText(
                                              leftText: "Admin",
                                              rightText: item['admin'] == 1
                                                  ? "Ya"
                                                  : "Tidak",
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
