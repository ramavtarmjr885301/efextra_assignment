import 'dart:convert';
import 'package:exefextra_assignment/Model/Organization_Model.dart';
import 'package:exefextra_assignment/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class OrganizationSelectionScreen extends StatefulWidget {
  const OrganizationSelectionScreen({super.key});

  @override
  State<OrganizationSelectionScreen> createState() =>
      _OrganizationSelectionScreenState();
}

class _OrganizationSelectionScreenState
    extends State<OrganizationSelectionScreen> {
  List<Organization_Details> organizationDetails = [];

  /// Sign out from Firebase Authentication.
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Fetch organization data from a REST API.
  Future<List<Organization_Details>> getData() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      organizationDetails = data
          .map((json) =>
              Organization_Details.fromJson(json as Map<String, dynamic>))
          .toList();
      return organizationDetails;
    } else {
      throw Exception('Failed to load organization details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios, color: Color(0xff312E49),),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.black,
            ),
            onPressed: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 245, 248, 248),

        // 0xff312E49 black 
                            //  0xff0097B2 blue
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
                color: Color(0xff312E49),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose the organization you want to manage or work with",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff312E49),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Organization_Details>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Data Available'));
                  }

                  return ListView.builder(
                    itemCount: organizationDetails.length,
                    itemBuilder: (context, index) {
                      final org = organizationDetails[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to details page, passing the organization details.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrganizationDetailsPage(
                                organization: org,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color:  Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.09),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                            ),
                            child: Row(
                              children: [
                                // Main card content
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 25,
                                    ),
                                    decoration:  BoxDecoration(
                                      color: Color.fromARGB(255, 189, 233, 240),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: const Color.fromARGB(255, 0, 148, 193),
                                          child: const Icon(
                                            Icons.apartment,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              org.id.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              org.userId.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                  width: 30,
                                  height: 120,
                                  decoration:  BoxDecoration(
                                   
                                    color: Color(0xff0097B2),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        shape: const CircleBorder(),
        child: const Icon(Icons.logout),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xff0097B2),
        height: 55,
      ),
    );
  }
}

// Details page that displays more information about an organization.
class OrganizationDetailsPage extends StatelessWidget {
  final Organization_Details organization;

  const OrganizationDetailsPage({Key? key, required this.organization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        title: const Text('Organization Details'),
        backgroundColor: const Color(0xff0097B2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organization ID: ${organization.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'User ID: ${organization.userId}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Optionally, display additional details if available.
            Text(
              'Title: ${organization.title}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${organization.body}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
