import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnlign/pages/peopleProfile.dart';
import 'package:learnlign/widgets/widgets.dart';

class UserSearchScreen extends SearchDelegate<String> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }
  @override
  ThemeData appBarTheme(BuildContext context) {
    // Customize the app bar theme for the search screen
    return Theme.of(context).copyWith(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white, // Set the text color to white
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white70,
          fontFamily: 'Quicksand'
        )
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.amber , // Set the background color of the app bar to black
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: usersCollection
              .where('fullName', isGreaterThanOrEqualTo: query)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No users found.'),
              );
            }
            List<QueryDocumentSnapshot> users = snapshot.data!.docs;

            // Exclude the current user from the list
            String currentUserId = FirebaseAuth.instance.currentUser!.uid;
            users = users.where((user) => user.id != currentUserId).toList();


            return Column(
              children: [
                SizedBox(height: 15,),
                Text('Results for "$query"', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),),
                SizedBox(height: 15,),
                Expanded(
                  child: ListView.builder(
                    itemCount:  users.length,
                    itemBuilder: (context, index) {
                      var userData = users[index].data() as Map<String, dynamic>?; // Nullable
                      var fullName = userData?['fullName'] as String?;
                      var userId = userData?['uid'] as String?;
                      var connetions= userData?['connections'] as List<dynamic>?;
                      var email = userData?['email'] as String?;// Nullable

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius:
                            BorderRadius.circular(15.0), // Set the border radius value
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                fullName!
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: (){
                                nextScreen(context, People(userName: fullName, userId: userId ?? '', con_no: connetions!.length));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber,
                                ),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: const Text("View",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            title: Text(fullName ?? '', style: TextStyle(color: Colors.white),), // Use null-aware operator to handle null value
                            //subtitle: Text(email ?? ''), // Use null-aware operator to handle null value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 100,),
            Center(
              child: SvgPicture.asset(
                'Assets/undraw_book_lover_re_rwjy.svg',
                semanticsLabel: 'My SVG Image',
                width: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Type user name in the search bar on the search screen to discover a wide range of results', style: TextStyle(color: Colors.white70, fontFamily: 'Quicksand'), textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    ); // Implement search suggestions if needed
  }
}


class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Connect', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: UserSearchScreen());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.amber,),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No users found.'),
              );
            }

            // Get the list of users from the snapshot
            List<QueryDocumentSnapshot> users = snapshot.data!.docs;

            String currentUserId = FirebaseAuth.instance.currentUser!.uid;
            users = users.where((user) => user.id != currentUserId).toList();

            // Display a maximum of 6 random users if the user count is more than 6
            List<QueryDocumentSnapshot> randomUsers;
            if (users.length > 6) {
              randomUsers = getRandomUsers(users, 6);
            } else {
              randomUsers = users;
            }

            return Column(
              children: [
                SizedBox(height: 30,),
                SvgPicture.asset(
                  'Assets/undraw_authentication_re_svpt.svg',
                  semanticsLabel: 'My SVG Image',
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28),
                  child: Center(child: Text('You can find people and can request them to connect and can have chats and calls with them...', style: TextStyle(color: Colors.white, fontFamily: 'Quicksand', fontSize: 10), textAlign: TextAlign.center,),),
                ),
                SizedBox(height: 30,),

                Expanded(
                  child: ListView.builder(
                    itemCount: randomUsers.length,
                    itemBuilder: (context, index) {
                      var userData = randomUsers[index].data() as Map<String, dynamic>?; // Nullable
                      var fullName = userData?['fullName'] as String?;
                      var userId = userData?['uid'] as String?;
                      var connetions= userData?['connections'] as List<dynamic>?;
                      var email = userData?['email'] as String?; // Nullable

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius:
                            BorderRadius.circular(15.0), // Set the border radius value
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                fullName!
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: (){
                                nextScreen(context, People(userName: fullName, userId: userId ?? '', con_no: connetions!.length,));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber,
                                ),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: const Text("View",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            title: Text(fullName ?? '', style: TextStyle(color: Colors.white),), // Use null-aware operator to handle null value
                            //subtitle: Text(email ?? ''), // Use null-aware operator to handle null value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper function to get a random list of users
  List<QueryDocumentSnapshot> getRandomUsers(List<QueryDocumentSnapshot> users, int maxUsers) {
    List<QueryDocumentSnapshot> randomUsers = [];
    List<int> randomIndices = [];
    int numberOfUsers = users.length;

    if (maxUsers >= numberOfUsers) {
      return users; // If the number of users is less than or equal to the maxUsers, return all users
    }

    while (randomIndices.length < maxUsers) {
      int randomIndex = Random().nextInt(numberOfUsers);
      if (!randomIndices.contains(randomIndex)) {
        randomIndices.add(randomIndex);
        randomUsers.add(users[randomIndex]);
      }
    }

    return randomUsers;
  }
}


