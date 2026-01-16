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
