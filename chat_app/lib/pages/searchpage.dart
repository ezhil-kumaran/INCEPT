import 'package:chat_app/services/database/databaseprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/pages/profilepage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final databaseprovider = Provider.of<Databaseprovider>(
    context,
    listen: false,
  );
  late final listeningprovider = Provider.of<Databaseprovider>(
    context,
    listen: true,
  );
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Users...',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 25),
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          onChanged: (value) {
            if (value.isNotEmpty) {
              databaseprovider.searchuserfromfirebase(value);
            } else {
              databaseprovider.searchuserfromfirebase(
                "",
              ); // Clear results if search is empty
            }
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: listeningprovider.searchresults.isEmpty
          ? Center(
              child: Text(
                'No results found',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : ListView.builder(
              itemCount: listeningprovider.searchresults.length,
              itemBuilder: (context, index) {
                final user = listeningprovider.searchresults[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 21,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    subtitle: Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    leading: Icon(Icons.person),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profilepage(uid: user.uid),
                      ),
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
