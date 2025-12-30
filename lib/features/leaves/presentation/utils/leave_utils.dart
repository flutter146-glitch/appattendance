// // lib/features/leaves/presentation/utils/leave_utils.dart

// import 'dart:io';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:excel/excel.dart' hide Border;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// class LeaveUtils {
//   /// Export filtered leaves to Excel file (saved in phone storage & auto-opened)
//   static Future<void> exportToExcel(
//     List<LeaveModel> filteredLeaves,
//     BuildContext context,
//   ) async {
//     // 1. Permission handling (Android 13+ support)
//     var status = await Permission.storage.request();
//     if (status.isDenied) {
//       status = await Permission.manageExternalStorage.request();
//     }
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Storage permission denied')),
//       );
//       return;
//     }

//     try {
//       // 2. Create Excel file
//       final excel = Excel.createExcel();
//       final sheet = excel['Leave Requests'];

//       // 3. Header row (using TextCellValue to avoid type errors)
//       sheet.appendRow([
//         TextCellValue('Employee ID'),
//         TextCellValue('Leave Type'),
//         TextCellValue('From Date'),
//         TextCellValue('To Date'),
//         TextCellValue('Duration'),
//         TextCellValue('Status'),
//         TextCellValue('Justification'),
//         TextCellValue('Manager Remarks'),
//         TextCellValue('Applied Date'),
//       ]);

//       // 4. Data rows (null-safe & formatted)
//       for (final leave in filteredLeaves) {
//         sheet.appendRow([
//           TextCellValue(leave.empId),
//           TextCellValue(leave.leaveType.name.toUpperCase()),
//           TextCellValue(DateFormat('dd/MM/yyyy').format(leave.leaveFromDate)),
//           TextCellValue(DateFormat('dd/MM/yyyy').format(leave.leaveToDate)),
//           TextCellValue(leave.duration),
//           TextCellValue(leave.approvalStatus.toUpperCase()),
//           TextCellValue(leave.justification),
//           TextCellValue(leave.managerComments ?? '-'),
//           TextCellValue(
//             DateFormat('dd/MM/yyyy HH:mm').format(leave.appliedDate),
//           ),
//         ]);
//       }

//       // 5. Save file
//       final directory = await getExternalStorageDirectory();
//       if (directory == null) {
//         throw Exception('External storage not available');
//       }

//       final fileName =
//           'Leave_Requests_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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
//           SnackBar(content: Text('Exported successfully: $fileName')),
//         );
//       }
//     } catch (e) {
//       debugPrint('Export error: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
//     }
//   }

//   /// Show search dialog (name / project / department)
//   static void showSearchDialog(
//     BuildContext context,
//     Function(String query) onSearchSubmitted,
//   ) {
//     String searchQuery = '';

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Search Leaves'),
//           content: TextField(
//             autofocus: true,
//             onChanged: (value) => searchQuery = value.trim().toLowerCase(),
//             decoration: const InputDecoration(
//               hintText: 'Search by name, project, department...',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (searchQuery.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please enter search term')),
//                   );
//                   return;
//                 }
//                 onSearchSubmitted(searchQuery);
//                 Navigator.pop(context);
//               },
//               child: const Text('Search'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
