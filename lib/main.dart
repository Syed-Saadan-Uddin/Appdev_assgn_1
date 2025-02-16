import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserProfileScreen(),
    );
  }
}
class CurvedArrowIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CurvedArrowIcon({super.key, this.size = 24.0, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CurvedArrowPainter(color),
    );
  }
}

class _CurvedArrowPainter extends CustomPainter {
  final Color color;

  _CurvedArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();
    
    // Main vertical line
    path.moveTo(size.width * 0.5, size.height * 0.2);  // Start from top
    path.lineTo(size.width * 0.5, size.height * 0.65); // Go straight down
    
    // Longer curve to the right at the bottom
    path.quadraticBezierTo(
      size.width * 0.5,   // control point x
      size.height * 0.7,  // control point y
      size.width * 0.75,  // end point x (moved further right)
      size.height * 0.7   // end point y
    );

    // Simple arrow head
    path.moveTo(size.width * 0.5, size.height * 0.2);   // Center
    path.lineTo(size.width * 0.35, size.height * 0.35);  // Left
    path.moveTo(size.width * 0.5, size.height * 0.2);   // Center
    path.lineTo(size.width * 0.65, size.height * 0.35);  // Right

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFCBF49),
                        Color(0xFFF77F00),
                        Color(0xFFDC7100)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 190,
                left: MediaQuery.of(context).size.width / 2 - 70,
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Text(
            'John Doe',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 10),
          const Text(
            "John Doe exists. John Doe builds. John Doe innovates. What's next? Only time will tell...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const TabSection(),
        ],
      ),
    );
  }
}


/// Custom clipper to create the wavy effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    
    // Start at top-left
    path.lineTo(0, 0);
    
    // Draw line to the starting point of the wave
    path.lineTo(0, size.height * 0.92);
    
    // First curve - brought control points closer horizontally
    path.quadraticBezierTo(
      size.width * 0.35, // moved closer to center (was 0.25)
      size.height * 0.65, // keeping deep curve
      size.width * 0.5, // end point x
      size.height * 0.95, // end point y
    );
    
    // Second curve - brought control points closer horizontally
    path.quadraticBezierTo(
      size.width * 0.70, // moved closer to center (was 0.75)
      size.height * 1.05, // keeping dramatic dip
      size.width, // end point x
      size.height * 0.92, // end point y
    );
    
    // Line to top-right corner
    path.lineTo(size.width, 0);
    
    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Tab section for Posts, Comments, and Stats
class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  _TabSectionState createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(text: "Posts"),
              Tab(text: "Comments"),
              Tab(text: "Stats"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                PostsTab(),
                CommentsTab(),
                StatsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sample posts tab
class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        eventCard("Champions Trophy ", "19 February 2025, 7:30 PM EST", "Karachi, Pakistan"),
        eventCard("Super Bowl", "9 February 2025, 6:30 PM EST", "New Orleans, Louisiana, USA"),
        eventCard("77th British Academy Film Awards (BAFTAs)", "16 February 2025, 7:00 PM GMT", " London, UK"),
        eventCard("67th Annual Grammy Awards", "23 February 2025, 5:00 PM PST", "Los Angeles, California, USA"),
        eventCard("95th Academy Awards (Oscars)", "30 March 2025, 5:00 PM PST", "Los Angeles, California, USA"),
      ],
    );
  }

  Widget eventCard(String title, String date, String location) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset("assets/event.jpeg", width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$date\n$location"),
        isThreeLine: true,
      ),
    );
  }
}

/// Comments Tab
class CommentsTab extends StatelessWidget {
  const CommentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        commentCard("Super Bowl", "'I let y’all down today. I’ll always continue to work and try and learn and be better for it.'", "10 February 2025, 6:29 PM"),
        commentCard("Super Bowl", "'I don’t like that one either. I just think you throw the ball high and he barely gets hit by the defense.'", "9 February 2025, 7:34 PM"),
        commentCard("Super Bowl Halftime Show", "Kendrick Lamar's performance sparks mixed reactions due to audio issues and controversial song choices.", "10 February 2025, 5:07 PM"),
        commentCard("95th Academy Awards", "Sean Penn criticizes the Academy's 'extraordinary cowardice' in limiting film diversity.", "5 February 2025, 10:00 AM"),
        commentCard("Emilia Pérez Film", "Lead star Karla Sofía Gascón faces backlash over resurfaced offensive comments, overshadowing the film's Oscar nominations.", "5 February 2025, 10:00 AM")

      ],
    );
  }

Widget commentCard(String title, String comment, String date) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: CurvedArrowIcon(size: 18, color: Colors.grey), // ✅ Fixed here
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '"$comment"',
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      const Divider(height: 1, color: Colors.grey), // Thin line below
    ],
  );
}

}


class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30), // Adjust this value to move the stats down
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            statItem("19", "Posts"),
            const SizedBox(width: 100), // Space between the items
            statItem("32", "Comments"),
          ],
        ),
      ],
    );
  }

  Widget statItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}

