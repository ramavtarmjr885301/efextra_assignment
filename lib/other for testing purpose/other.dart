import 'package:exefextra_assignment/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class OrganizationSelectionScreen extends StatefulWidget {
  OrganizationSelectionScreen({super.key});

  @override
  State<OrganizationSelectionScreen> createState() =>
      _OrganizationSelectionScreenState();
}

class _OrganizationSelectionScreenState
    extends State<OrganizationSelectionScreen> {
  final List<Map<String, dynamic>> organizations = List.generate(
    10,
    (index) => {'name': 'Tech Corp', 'size': 12},
  );

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.black,
            ),
            onPressed: () {
              themeNotifier.value =
                  themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your Organization",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose The organization you want to manage or work with",
              style: TextStyle(fontSize: 16, color: Colors.cyan),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetailsPage(
                                name: organizations[index]['name'],
                                size: organizations[index]['size'],
                              ),
                        ),
                      );
                    },
                    child: OrganizationCard(
                      name: organizations[index]['name'],
                      size: organizations[index]['size'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
        },
        child: const Icon(Icons.logout),
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(color: Colors.cyan, height: 55),
    );
  }
}

class OrganizationCard extends StatefulWidget {
  final String name;
  final int size;

  const OrganizationCard({super.key, required this.name, required this.size});

  @override
  State<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
        child: Row(
          children: [
            // Main card content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                color: const Color(0xFFE0F7FA), // Light cyan background
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF00ACC1), // Teal
                      child: const Icon(
                        Icons.apartment,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Size: ${widget.size}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right accent strip
            Container(
              width: 20,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF00BCD4), // Cyan accent
                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final String name;
  final int size;

  const DetailsPage({super.key, required this.name, required this.size});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Center(
        child: Text("Welcome to ${widget.name} with size ${widget.size}"),
      ),
    );
  }
}
