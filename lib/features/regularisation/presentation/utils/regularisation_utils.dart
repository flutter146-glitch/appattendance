// // lib/features/regularisation/presentation/utils/regularisation_utils.dart

// import 'dart:io';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:excel/excel.dart' hide Border;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';

// class RegularisationUtils {
//   static Future<void> exportToExcel(
//     List<RegularisationRequest> requests,
//     BuildContext context,
//   ) async {
//     // 1. Permissions handle (Android 13+ ke liye manageExternalStorage bhi)
//     var status = await Permission.storage.request();
//     if (status.isDenied) {
//       status = await Permission.manageExternalStorage.request();
//     }
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Storage permission required to export')),
//       );
//       return;
//     }

//     try {
//       // 2. Create Excel file
//       final excel = Excel.createExcel();
//       final sheet = excel['Regularisation Requests'];

//       // 3. Header row
//       sheet.appendRow([
//         'Employee Name',
//         'Designation',
//         'Applied Date',
//         'For Date',
//         'Type',
//         'Status',
//         'Justification',
//         'Shortfall',
//         'Check-in',
//         'Check-out',
//         'Projects',
//       ]);

//       // 4. Data rows (null-safe)
//       for (final req in requests) {
//         sheet.appendRow([
//           req.empName ?? 'Unknown',
//           req.designation ?? '-',
//           req.appliedDate ?? '-',
//           req.forDate ?? '-',
//           req.type ?? '-',
//           req.status ?? '-',
//           req.justification ?? '-',
//           req.shortfall ?? '-',
//           req.checkinTime ?? '-',
//           req.checkoutTime ?? '-',
//           req.projectNames.isNotEmpty ? req.projectNames.join(', ') : '-',
//         ]);
//       }

//       // 5. Save file
//       final directory = await getExternalStorageDirectory();
//       if (directory == null) {
//         throw Exception('External storage not available');
//       }

//       final fileName =
//           'Regularisation_Requests_${DateTime.now().millisecondsSinceEpoch}.xlsx';
//       final path = '${directory.path}/$fileName';

//       final file = File(path);
//       await file.create(recursive: true);
//       await file.writeAsBytes(excel.encode()!);

//       // 6. Open file
//       final result = await OpenFile.open(path);
//       if (result.type != ResultType.done) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('File open failed: ${result.message}')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Exported successfully to: $fileName')),
//         );
//       }
//     } catch (e) {
//       debugPrint('Export error: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
//     }
//   }
// }
