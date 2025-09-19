import 'package:flutter/material.dart';
import 'issue_status_page.dart';

class MyIssuesScreen extends StatelessWidget {
  const MyIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        title: const Text("My Issues"),
      ),
      body: const IssuesBody(),
    );
  }
}

/// Just for show the skeleton we use [StatefulWidget]
class IssuesBody extends StatefulWidget {
  const IssuesBody({super.key});

  @override
  State<IssuesBody> createState() => _IssuesBodyState();
}

class _IssuesBodyState extends State<IssuesBody> {
  bool isLoading = true;
  int demoDataLength = 3;

  // Sample user issues data
  final List<Map<String, dynamic>> userIssues = [
    {
      'id': 1,
      'title': 'Broken Street Light on Main Road',
      'description': 'The street light near the bus stop has been broken for 3 days, making it dangerous at night.',
      'location': 'Main Road, Sector 15',
      'status': 'In Progress',
      'priority': 'High',
      'category': 'Infrastructure',
      'date': 'Dec 18, 2024',
      'assignedTo': 'Public Works Department',
      'estimatedResolution': 'Dec 25, 2024',
    },
    {
      'id': 2,
      'title': 'Water Leakage in Park',
      'description': 'Continuous water leakage from the main pipe creating muddy conditions in the children\'s play area.',
      'location': 'Central Park, Zone A',
      'status': 'Resolved',
      'priority': 'Medium',
      'category': 'Water Supply',
      'date': 'Dec 16, 2024',
      'assignedTo': 'Water Works Department',
      'estimatedResolution': 'Dec 20, 2024',
    },
    {
      'id': 3,
      'title': 'Pothole on Highway',
      'description': 'Large pothole causing traffic issues and vehicle damage near the shopping complex.',
      'location': 'Highway 101, KM 45',
      'status': 'Pending',
      'priority': 'High',
      'category': 'Roads',
      'date': 'Dec 19, 2024',
      'assignedTo': null,
      'estimatedResolution': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: isLoading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: IssueCardSkeleton(),
                ),
              )
            : demoDataLength > 0
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: userIssues.length,
                          itemBuilder: (context, index) {
                            final issue = userIssues[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: IssueInfoCard(
                                title: issue['title'],
                                description: issue['description'],
                                status: issue['status'],
                                statusColor: _getStatusColor(issue['status']),
                                date: issue['date'],
                                priority: issue['priority'],
                                category: issue['category'],
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IssueStatusPage(issue: issue),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const NoIssuesFound(),
      ),
    );
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
}

class IssueInfoCard extends StatelessWidget {
  const IssueInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.priority,
    required this.category,
    required this.press,
  });

  final String title, description, status, date, priority, category;
  final Color statusColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Priority and Category Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: _getPriorityColor(priority),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFF667eea),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      case 'Critical':
        return Colors.red[900]!;
      default:
        return Colors.grey;
    }
  }
}

class NoIssuesFound extends StatelessWidget {
  const NoIssuesFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.report_problem_outlined,
              size: 60,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Issues Reported",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "You haven't reported any issues yet. Tap the + button to report your first issue.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class IssueCardSkeleton extends StatelessWidget {
  const IssueCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: SkeletonLine(width: 150, height: 18),
              ),
              const SizedBox(width: 12),
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonLine(height: 14),
          const SizedBox(height: 8),
          const SkeletonLine(width: 200, height: 14),
          const SizedBox(height: 16),
          const Row(
            children: [
              SkeletonLine(width: 100, height: 12),
              Spacer(),
              SkeletonLine(width: 16, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.height = 16, this.width = double.infinity});
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
