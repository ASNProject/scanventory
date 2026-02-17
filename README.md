# scanventory

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

url = https://script.google.com/macros/s/AKfycbwqVfqDpTSpQ8r-kup9o5-J5mPkqGIFRAuFhHQ3Kr7PG9focYr_Jc1SJsN3cHJo00PCyA/exec

script: 
function doGet(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = sheet.getDataRange().getValues();
  
  var barcode = e.parameter.barcode;
  
  for (var i = 1; i < data.length; i++) {
    if (data[i][0] == barcode) {
      return ContentService.createTextOutput(JSON.stringify({
        nama: data[i][1],
        harga: data[i][2],
        stok: data[i][3]
      })).setMimeType(ContentService.MimeType.JSON);
    }
  }

  return ContentService.createTextOutput(JSON.stringify({
    error: "Data tidak ditemukan"
  })).setMimeType(ContentService.MimeType.JSON);
}