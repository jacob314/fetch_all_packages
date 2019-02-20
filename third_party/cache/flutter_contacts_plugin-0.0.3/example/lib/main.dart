import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter_contacts_plugin/flutter_contacts_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: <String, WidgetBuilder>{
    }, home: ContactListPage());
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  Iterable<Contact> _contacts;

  @override
  initState() {
    super.initState();
    refreshContacts();
  }

  refreshContacts() async {
    var contacts = await FlutterContactsPlugin.getContacts();
    print(contacts);
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts Plugin Example')),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            refreshContacts();

          }),
      body: SafeArea(
        child: _contacts != null
            ? ListView.builder(
          itemCount: _contacts?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            Contact c = _contacts?.elementAt(index);
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ContactDetailsPage(c)));
              },
              leading: (c.avatar != null && c.avatar.length > 0)
                  ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                  : CircleAvatar(
                backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
                child: Text(c.displayName != null && c.displayName.length > 0
                    ? c.displayName?.substring(0, 2)
                    : ""),
                foregroundColor: Colors.white,),
              title: Text(c.displayName ?? ""),
            );
          },
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ContactDetailsPage extends StatelessWidget {
  ContactDetailsPage(this._contact);
  final Contact _contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(title: Text(_contact.displayName ?? ""), actions: <Widget>[
          FlatButton(
              child: Icon(Icons.delete),
              onPressed: () {
                FlutterContactsPlugin.deleteContact(_contact);
              })
        ]),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              ListTile(
                  title: Text("Name"),
                  trailing: Text(_contact.givenName ?? "")),
              ListTile(
                  title: Text("Middle name"),
                  trailing: Text(_contact.middleName ?? "")),
              ListTile(
                  title: Text("Family name"),
                  trailing: Text(_contact.familyName ?? "")),
              ListTile(
                  title: Text("Prefix"), trailing: Text(_contact.prefix ?? "")),
              ListTile(
                  title: Text("Suffix"), trailing: Text(_contact.suffix ?? "")),
              ListTile(
                  title: Text("Company"),
                  trailing: Text(_contact.company ?? "")),
              ListTile(
                  title: Text("Job"), trailing: Text(_contact.jobTitle ?? "")),
              AddressesTile(_contact.postalAddresses),
              ItemsTile("Phones", _contact.phones),
              ItemsTile("Emails", _contact.emails)
            ],
          ),
        ));
  }
}

class AddressesTile extends StatelessWidget {
  AddressesTile(this._addresses);
  final Iterable<PostalAddress> _addresses;

  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(title: Text("Addresses")),
          Column(
              children: _addresses
                  .map((a) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: Text("Street"),
                        trailing: Text(a.street)),
                    ListTile(
                        title: Text("Postcode"),
                        trailing: Text(a.postcode)),
                    ListTile(
                        title: Text("City"), trailing: Text(a.city)),
                    ListTile(
                        title: Text("Region"),
                        trailing: Text(a.region)),
                    ListTile(
                        title: Text("Country"),
                        trailing: Text(a.country)),
                  ],
                ),
              ))
                  .toList())
        ]);
  }
}

class ItemsTile extends StatelessWidget {
  ItemsTile(this._title, this._items);
  final Iterable<Item> _items;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(title: Text(_title)),
          Column(
              children: _items
                  .map((i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                      title: Text(i.label ?? ""),
                      trailing: Text(i.value ?? ""))))
                  .toList())
        ]);
  }
}

