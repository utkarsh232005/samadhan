import 'package:flutter/material.dart';

class IssueStatusPage extends StatelessWidget {
  final Map<String, dynamic> issue;

  const IssueStatusPage({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    final statusTimeline = _getStatusTimeline(issue['status']);
    final currentStatusIndex = _getCurrentStatusIndex(issue['status']);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        title: const Text('Issue Status'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card with Issue Info
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667eea).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIssueIcon(issue['category']),
                          color: const Color(0xFF667eea),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Issue ID: #${issue['id'].toString().padLeft(6, '0')}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(issue['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(issue['status']),
                          size: 16,
                          color: _getStatusColor(issue['status']),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          issue['status'],
                          style: TextStyle(
                            color: _getStatusColor(issue['status']),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Status Timeline
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: statusTimeline.length,
                    itemBuilder: (context, index) {
                      final timelineItem = statusTimeline[index];
                      final isCompleted = index <= currentStatusIndex;
                      final isActive = index == currentStatusIndex;
                      
                      return TimelineItem(
                        title: timelineItem['title'] ?? '',
                        description: timelineItem['description'] ?? '',
                        time: timelineItem['time'] ?? '',
                        isCompleted: isCompleted,
                        isActive: isActive,
                        isLast: index == statusTimeline.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Issue Details Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Issue Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Description', issue['description']),
                  _buildDetailRow('Location', issue['location']),
                  _buildDetailRow('Category', issue['category']),
                  _buildDetailRow('Priority', issue['priority']),
                  _buildDetailRow('Reported Date', issue['date']),
                  if (issue['assignedTo'] != null)
                    _buildDetailRow('Assigned To', issue['assignedTo']),
                  if (issue['estimatedResolution'] != null)
                    _buildDetailRow('Estimated Resolution', issue['estimatedResolution']),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getStatusTimeline(String currentStatus) {
    final timeline = [
      {
        'title': 'Issue Reported',
        'description': 'Your issue has been successfully submitted',
        'time': issue['date'],
      },
      {
        'title': 'Under Review',
        'description': 'Issue is being reviewed by our team',
        'time': _getTimeForStatus('Under Review', currentStatus),
      },
      {
        'title': 'In Progress',
        'description': 'Work has started on resolving this issue',
        'time': _getTimeForStatus('In Progress', currentStatus),
      },
      {
        'title': 'Testing/Verification',
        'description': 'Resolution is being tested and verified',
        'time': _getTimeForStatus('Testing', currentStatus),
      },
      {
        'title': 'Resolved',
        'description': 'Issue has been successfully resolved',
        'time': _getTimeForStatus('Resolved', currentStatus),
      },
    ];

    return timeline;
  }

  String _getTimeForStatus(String status, String currentStatus) {
    // This would typically come from your backend/database
    // For demo purposes, we'll generate some sample times
    if (currentStatus == 'Pending') {
      return status == 'Under Review' ? '' : '';
    } else if (currentStatus == 'In Progress') {
      switch (status) {
        case 'Under Review':
          return 'Dec 19, 2024';
        case 'In Progress':
          return 'Dec 20, 2024';
        default:
          return '';
      }
    } else if (currentStatus == 'Resolved') {
      switch (status) {
        case 'Under Review':
          return 'Dec 19, 2024';
        case 'In Progress':
          return 'Dec 20, 2024';
        case 'Testing':
          return 'Dec 21, 2024';
        case 'Resolved':
          return 'Dec 22, 2024';
        default:
          return '';
      }
    }
    return '';
  }

  int _getCurrentStatusIndex(String status) {
    switch (status) {
      case 'Pending':
        return 0;
      case 'In Progress':
        return 2;
      case 'Resolved':
        return 4;
      default:
        return 0;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.pending;
      case 'In Progress':
        return Icons.autorenew;
      case 'Resolved':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  IconData _getIssueIcon(String category) {
    switch (category) {
      case 'Infrastructure':
        return Icons.construction;
      case 'Roads':
        return Icons.directions_car;
      case 'Water Supply':
        return Icons.water_drop;
      case 'Electricity':
        return Icons.electric_bolt;
      case 'Waste Management':
        return Icons.delete;
      case 'Public Transport':
        return Icons.directions_bus;
      case 'Safety & Security':
        return Icons.security;
      case 'Environment':
        return Icons.eco;
      case 'Healthcare':
        return Icons.local_hospital;
      case 'Education':
        return Icons.school;
      default:
        return Icons.report_problem;
    }
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFF667eea)
                    : Colors.grey.shade300,
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF667eea)
                      : Colors.grey.shade300,
                  width: isActive ? 3 : 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? const Color(0xFF667eea)
                    : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? const Color(0xFF667eea) : Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
