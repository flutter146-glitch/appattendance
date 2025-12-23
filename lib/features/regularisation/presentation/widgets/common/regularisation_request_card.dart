// lib/features/regularisation/presentation/widgets/regularisation_request_card.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegularisationRequestCard extends StatelessWidget {
  final RegularisationRequest request;
  final bool isDark;
  final bool showActions;
  final bool isEmployeeView;

  const RegularisationRequestCard({
    super.key,
    required this.request,
    required this.isDark,
    this.showActions = false,
    this.isEmployeeView = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = request.status == 'pending'
        ? Colors.orange
        : Colors.green;

    if (isEmployeeView) {
      // Simplified Employee View (exact 3rd image)
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? Colors.grey.shade800 : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + Day + Status
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    DateFormat(
                      'dd/MM/yy',
                    ).format(DateTime.parse(request.forDate)),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE').format(DateTime.parse(request.forDate)),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Check-in Hr + Shortfall Hr + Regularize
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Check-in Hr",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        request.checkinTime ?? '--',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Shortfall Hr",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        request.shortfall ?? '--',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Regularize",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Icon(
                        request.status == 'approved'
                            ? Icons.check_circle
                            : Icons.pending,
                        color: request.status == 'approved'
                            ? Colors.green
                            : Colors.orange,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Projects
              if (request.projectNames.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        request.projectNames.join(', '),
                        style: TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
    // if (isEmployeeView) {
    //   // Simplified Employee View (exact 3rd image)
    //   return Card(
    //     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //     elevation: 6,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //     color: isDark ? Colors.grey.shade800 : Colors.white,
    //     child: Padding(
    //       padding: EdgeInsets.all(16),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // Date + Day + Status
    //           Row(
    //             children: [
    //               Container(
    //                 padding: EdgeInsets.all(8),
    //                 decoration: BoxDecoration(
    //                   color: Colors.blue.withOpacity(0.1),
    //                   borderRadius: BorderRadius.circular(12),
    //                 ),
    //                 child: Icon(
    //                   Icons.calendar_today,
    //                   color: Colors.blue,
    //                   size: 20,
    //                 ),
    //               ),
    //               SizedBox(width: 12),
    //               Text(
    //                 DateFormat(
    //                   'dd/MM/yy',
    //                 ).format(DateTime.parse(request.forDate)),
    //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //               ),
    //               SizedBox(width: 8),
    //               Text(
    //                 DateFormat('EEEE').format(DateTime.parse(request.forDate)),
    //                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    //               ),
    //               Spacer(),
    //               Container(
    //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    //                 decoration: BoxDecoration(
    //                   color: statusColor.withOpacity(0.2),
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 child: Text(
    //                   request.status.toUpperCase(),
    //                   style: TextStyle(
    //                     color: statusColor,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 12,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           SizedBox(height: 16),
    //           // Check-in Hr + Shortfall Hr + Regularize
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     "Check-in Hr",
    //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    //                   ),
    //                   SizedBox(height: 4),
    //                   Text(
    //                     request.checkinTime ?? '--',
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     "Shortfall Hr",
    //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    //                   ),
    //                   SizedBox(height: 4),
    //                   Text(
    //                     request.shortfall ?? '--',
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                       color: Colors.red,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 children: [
    //                   Text(
    //                     "Regularize",
    //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    //                   ),
    //                   SizedBox(height: 4),
    //                   Icon(
    //                     request.status == 'approved'
    //                         ? Icons.check_circle
    //                         : Icons.pending,
    //                     color: request.status == 'approved'
    //                         ? Colors.green
    //                         : Colors.orange,
    //                     size: 24,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           SizedBox(height: 16),
    //           // Project
    //           if (request.projectNames.isNotEmpty)
    //             Container(
    //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    //               decoration: BoxDecoration(
    //                 color: Colors.blue.withOpacity(0.1),
    //                 borderRadius: BorderRadius.circular(20),
    //               ),
    //               child: Row(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Icon(Icons.folder, size: 16, color: Colors.blue),
    //                   SizedBox(width: 8),
    //                   Text(
    //                     request.projectNames.join(', '),
    //                     style: TextStyle(color: Colors.blue, fontSize: 13),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    else {
      return Card(
        // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: isDark ? Colors.grey.shade800 : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row — Avatar + Name + Designation + Status + Projects
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: statusColor,
                    child: Text(
                      request.empName
                          .split(' ')
                          .map((e) => e[0].toUpperCase())
                          .take(2)
                          .join(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Name + Designation + Status
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.empName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          request.designation,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            request.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 1),

                  // Projects — right side, flexible
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Projects:",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 6),
                        ...request.projectNames.map((project) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 4),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.folder,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    project,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Date + Type badge
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
                  SizedBox(width: 10),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(DateTime.parse(request.forDate)),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          color: Colors.blue,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          request.type,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Check-in & Out + Shortfall
              if (request.checkinTime != null ||
                  request.checkoutTime != null ||
                  request.shortfall != null)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Icon(Icons.login, color: Colors.green, size: 18),
                                // SizedBox(width: 4),
                                Text(
                                  "Check IN & OUT Time",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${request.checkinTime ?? '--'} - ${request.checkoutTime ?? '--'}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (request.shortfall != null)
                        Column(
                          children: [
                            Text(
                              "Shortfall",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              request.shortfall!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

              SizedBox(height: 10),

              // Reason
              Text(
                request.justification,
                style: TextStyle(fontSize: 12, height: 1.6),
              ),

              // Action Required
              if (request.status == 'pending')
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Action Required",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}

// // lib/features/regularisation/presentation/widgets/regularisation_request_card.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationRequestCard extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool isDark;
//   final bool showActions;

//   const RegularisationRequestCard({
//     super.key,
//     required this.request,
//     required this.isDark,
//     this.showActions = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : Colors.green;

//     return Card(
//       // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: isDark ? Colors.grey.shade800 : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Row — Avatar + Name + Designation + Status + Projects
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Avatar
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: statusColor,
//                   child: Text(
//                     request.empName
//                         .split(' ')
//                         .map((e) => e[0].toUpperCase())
//                         .take(2)
//                         .join(),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),

//                 // Name + Designation + Status
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         request.empName,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: isDark ? Colors.white : Colors.black87,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         request.designation,
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 6),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: statusColor.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Text(
//                           request.status.toUpperCase(),
//                           style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(width: 1),

//                 // Projects — right side, flexible
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "Projects:",
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                       SizedBox(height: 6),
//                       ...request.projectNames.map((project) {
//                         return Container(
//                           margin: EdgeInsets.only(bottom: 4),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 5,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.folder, size: 14, color: Colors.blue),
//                               SizedBox(width: 2),
//                               Flexible(
//                                 child: Text(
//                                   project,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.blue,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 20),

//             // Date + Type badge
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
//                 SizedBox(width: 10),
//                 Text(
//                   DateFormat(
//                     'dd/MM/yyyy',
//                   ).format(DateTime.parse(request.forDate)),
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//                 ),
//                 Spacer(),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.access_time_filled,
//                         color: Colors.blue,
//                         size: 18,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         request.type,
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             // Check-in & Out + Shortfall
//             if (request.checkinTime != null ||
//                 request.checkoutTime != null ||
//                 request.shortfall != null)
//               Container(
//                 margin: EdgeInsets.only(top: 16),
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               // Icon(Icons.login, color: Colors.green, size: 18),
//                               // SizedBox(width: 4),
//                               Text(
//                                 "Check IN & OUT Time",
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "${request.checkinTime ?? '--'} - ${request.checkoutTime ?? '--'}",
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (request.shortfall != null)
//                       Column(
//                         children: [
//                           Text(
//                             "Shortfall",
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             request.shortfall!,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),

//             SizedBox(height: 10),

//             // Reason
//             Text(
//               request.justification,
//               style: TextStyle(fontSize: 12, height: 1.6),
//             ),

//             // Action Required
//             if (request.status == 'pending')
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.warning_amber_rounded,
//                       color: Colors.orange,
//                       size: 24,
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Action Required",
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_request_card.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationRequestCard extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool isDark;
//   final bool showActions;

//   const RegularisationRequestCard({
//     super.key,
//     required this.request,
//     required this.isDark,
//     this.showActions = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: isDark ? Colors.grey.shade800 : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Row: Avatar + Name + Designation + Status
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Avatar
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: statusColor,
//                   child: Text(
//                     request.empName
//                         .split(' ')
//                         .map((e) => e[0].toUpperCase())
//                         .take(2)
//                         .join(),
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),

//                 // Name + Designation
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         request.empName,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: isDark ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                       Text(
//                         request.designation,
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         request.status == 'pending' ? 'Pending' : 'Approved',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Projects right side vertical chips
//                 Container(
//                   width: 120,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "Projects:",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: isDark ? Colors.grey[400] : Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       ...request.projectNames.map((project) {
//                         return Container(
//                           margin: EdgeInsets.only(bottom: 4),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             project,
//                             style: TextStyle(fontSize: 12, color: Colors.blue),
//                             textAlign: TextAlign.right,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 20),

//             // Date + Full Day
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   DateFormat(
//                     'dd/MM/yyyy',
//                   ).format(DateTime.parse(request.forDate)),
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(width: 24),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     request.type,
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // Check-in/Out + Shortfall
//             if (request.checkinTime != null ||
//                 request.checkoutTime != null ||
//                 request.shortfall != null) ...[
//               SizedBox(height: 12),
//               if (request.checkinTime != null)
//                 Row(
//                   children: [
//                     Icon(Icons.login, color: Colors.green, size: 18),
//                     SizedBox(width: 8),
//                     Text(
//                       "Check-in: ${request.checkinTime}",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               if (request.checkoutTime != null)
//                 Row(
//                   children: [
//                     Icon(Icons.logout, color: Colors.purple, size: 18),
//                     SizedBox(width: 8),
//                     Text(
//                       "Check-out: ${request.checkoutTime}",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               if (request.shortfall != null)
//                 Row(
//                   children: [
//                     Icon(Icons.timer, color: Colors.red, size: 18),
//                     SizedBox(width: 8),
//                     Text(
//                       "Shortfall: ${request.shortfall}",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//             ],

//             SizedBox(height: 16),

//             // Reason
//             Text(
//               request.justification,
//               style: TextStyle(fontSize: 14, height: 1.5),
//             ),

//             // Action Required
//             if (request.status == 'pending')
//               Container(
//                 margin: EdgeInsets.only(top: 16),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.warning, color: Colors.orange, size: 20),
//                     SizedBox(width: 8),
//                     Text(
//                       "Action Required",
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_request_card.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationRequestCard extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool isDark;
//   final bool showActions;

//   const RegularisationRequestCard({
//     super.key,
//     required this.request,
//     required this.isDark,
//     this.showActions = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       elevation: 10,
//       shadowColor: Colors.black.withOpacity(0.12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: isDark ? Colors.grey.shade800 : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header: Avatar + Name + Designation + Status
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Avatar
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: statusColor.withOpacity(0.2),
//                   child: Text(
//                     request.empName
//                         .split(' ')
//                         .map((e) => e[0].toUpperCase())
//                         .take(2)
//                         .join(),
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: statusColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),

//                 // Left: Name + Designation + Date + Type + Time Details + Reason
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Name + Status
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               request.empName,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: statusColor.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(30),
//                               border: Border.all(
//                                 color: statusColor.withOpacity(0.6),
//                                 width: 1.2,
//                               ),
//                             ),
//                             child: Text(
//                               request.status.toUpperCase(),
//                               style: TextStyle(
//                                 color: statusColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         request.designation,
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),

//                       SizedBox(height: 16),

//                       // Date & Type
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today_rounded,
//                             color: Colors.grey[600],
//                             size: 20,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             DateFormat(
//                               'dd/MM/yyyy',
//                             ).format(DateTime.parse(request.forDate)),
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(width: 24),
//                           Icon(
//                             Icons.access_time_rounded,
//                             color: Colors.grey[600],
//                             size: 20,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             request.type,
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),

//                       // Check-in / Checkout / Shortfall
//                       if (request.checkinTime != null ||
//                           request.checkoutTime != null ||
//                           request.shortfall != null) ...[
//                         SizedBox(height: 12),
//                         if (request.checkinTime != null)
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.login_rounded,
//                                 color: Colors.blue[700],
//                                 size: 18,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Check-in: ${request.checkinTime}",
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         if (request.checkoutTime != null)
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.logout_rounded,
//                                 color: Colors.purple[700],
//                                 size: 18,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Check-out: ${request.checkoutTime}",
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         if (request.shortfall != null)
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.timer_off_rounded,
//                                 color: Colors.red,
//                                 size: 18,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Shortfall: ${request.shortfall}",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],

//                       SizedBox(height: 20),

//                       // Reason
//                       Text(
//                         request.justification,
//                         style: TextStyle(
//                           fontSize: 14.5,
//                           height: 1.5,
//                           color: isDark ? Colors.white70 : Colors.black87,
//                         ),
//                       ),

//                       // Action Required Badge
//                       if (request.status == 'pending')
//                         Container(
//                           margin: EdgeInsets.only(top: 20),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.orange.withOpacity(0.7),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.warning_amber_rounded,
//                                 color: Colors.orange,
//                                 size: 22,
//                               ),
//                               SizedBox(width: 12),
//                               Text(
//                                 "Action Required",
//                                 style: TextStyle(
//                                   color: Colors.orange,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       // Approve/Reject Buttons
//                       if (showActions)
//                         Padding(
//                           padding: EdgeInsets.only(top: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: () {},
//                                 icon: Icon(Icons.check_circle, size: 18),
//                                 label: Text("Approve"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 12),
//                               ElevatedButton.icon(
//                                 onPressed: () {},
//                                 icon: Icon(Icons.cancel, size: 18),
//                                 label: Text("Reject"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(width: 16),

//                 // Right: Projects List (exactly like the code you showed)
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     constraints: BoxConstraints(maxHeight: 120),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           'Projects:',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: isDark ? Colors.grey[400] : Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: request.projectNames.isEmpty
//                                   ? [
//                                       Text(
//                                         'No Projects Assigned',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[500],
//                                           fontStyle: FontStyle.italic,
//                                         ),
//                                         textAlign: TextAlign.right,
//                                       ),
//                                     ]
//                                   : request.projectNames.map((project) {
//                                       return Container(
//                                         margin: EdgeInsets.only(bottom: 4),
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 10,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: isDark
//                                               ? Colors.blue.shade800
//                                               : Colors.blue.shade50,
//                                           borderRadius: BorderRadius.circular(
//                                             6,
//                                           ),
//                                         ),
//                                         child: Text(
//                                           project,
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: isDark
//                                                 ? Colors.blue.shade200
//                                                 : Colors.blue.shade700,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           textAlign: TextAlign.right,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                       );
//                                     }).toList(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_request_card.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationRequestCard extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool isDark;
//   final bool showActions; // Approve/Reject buttons (only for allowed managers)

//   const RegularisationRequestCard({
//     super.key,
//     required this.request,
//     required this.isDark,
//     this.showActions = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       elevation: 12,
//       shadowColor: Colors.black.withOpacity(0.15),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       color: isDark ? Colors.grey.shade800 : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header: Avatar + Name + Status
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 32,
//                   backgroundColor: statusColor.withOpacity(0.2),
//                   child: Text(
//                     request.empName
//                         .split(' ')
//                         .map((e) => e[0].toUpperCase())
//                         .take(2)
//                         .join(),
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: statusColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         request.empName,
//                         style: TextStyle(
//                           fontSize: 19,
//                           fontWeight: FontWeight.bold,
//                           color: isDark ? Colors.white : Colors.black87,
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         request.designation,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(
//                       color: statusColor.withOpacity(0.6),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Text(
//                     request.status.toUpperCase(),
//                     style: TextStyle(
//                       color: statusColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 28),

//             // Date & Type
//             Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today_rounded,
//                   color: Colors.grey[600],
//                   size: 22,
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   DateFormat(
//                     'dd/MM/yyyy',
//                   ).format(DateTime.parse(request.forDate)),
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(width: 32),
//                 Icon(
//                   Icons.access_time_rounded,
//                   color: Colors.grey[600],
//                   size: 22,
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   request.type,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),

//             // Check-in / Checkout / Shortfall
//             if (request.checkinTime != null ||
//                 request.checkoutTime != null) ...[
//               SizedBox(height: 16),
//               if (request.checkinTime != null)
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.login_rounded,
//                       color: Colors.blue[700],
//                       size: 20,
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Check-in: ${request.checkinTime}",
//                       style: TextStyle(fontSize: 15),
//                     ),
//                   ],
//                 ),
//               if (request.checkoutTime != null)
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.logout_rounded,
//                       color: Colors.purple[700],
//                       size: 20,
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       "Check-out: ${request.checkoutTime}",
//                       style: TextStyle(fontSize: 15),
//                     ),
//                   ],
//                 ),
//               if (request.shortfall != null)
//                 Row(
//                   children: [
//                     Icon(Icons.timer_off_rounded, color: Colors.red, size: 20),
//                     SizedBox(width: 12),
//                     Text(
//                       "Shortfall: ${request.shortfall}",
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//             ],

//             SizedBox(height: 24),

//             // Reason
//             Text(
//               request.justification,
//               style: TextStyle(
//                 fontSize: 15.5,
//                 height: 1.6,
//                 color: isDark ? Colors.white70 : Colors.black87,
//               ),
//             ),

//             SizedBox(height: 24),

//             // Projects Chips
//             if (request.projectNames.isNotEmpty)
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   Text(
//                     "Projects:",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: isDark ? Colors.white70 : Colors.black87,
//                     ),
//                   ),
//                   ...request.projectNames.map((project) {
//                     return Chip(
//                       label: Text(
//                         project,
//                         style: TextStyle(fontSize: 14, color: Colors.white),
//                       ),
//                       backgroundColor: AppColors.primary,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 6,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),

//             // Action Required Badge
//             if (request.status == 'pending')
//               Container(
//                 margin: EdgeInsets.only(top: 28),
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(
//                     color: Colors.orange.withOpacity(0.7),
//                     width: 2,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.warning_amber_rounded,
//                       color: Colors.orange,
//                       size: 26,
//                     ),
//                     SizedBox(width: 16),
//                     Text(
//                       "Action Required",
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//             // Approve/Reject Buttons (only if allowed)
//             if (showActions)
//               Padding(
//                 padding: EdgeInsets.only(top: 24),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // Approve logic
//                       },
//                       icon: Icon(Icons.check_circle, size: 20),
//                       label: Text("Approve", style: TextStyle(fontSize: 16)),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // Reject logic
//                       },
//                       icon: Icon(Icons.cancel, size: 20),
//                       label: Text("Reject", style: TextStyle(fontSize: 16)),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
