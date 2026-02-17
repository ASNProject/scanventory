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

import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  final String leftText;
  final String rightText;
  final bool title;

  const RowText({
    super.key,
    required this.leftText,
    required this.rightText,
    this.title = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              color: title ? Colors.black : Colors.grey,
              fontWeight: title ? FontWeight.bold : FontWeight.w600,
              fontSize: title ? 14 : 12,
            ),
          ),
          Flexible(
            child: Text(
              rightText,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: title ? 14 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
