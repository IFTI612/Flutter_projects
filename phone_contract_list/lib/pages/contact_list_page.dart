import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {

  final TextEditingController _nameController =TextEditingController();
  final TextEditingController _numberController =TextEditingController();
  final List<Map<String,String>>_contacts =[];



    ///this this add function for the contract list
  void _addContact()
  {
    String name = _nameController.text.trim();
    String number = _numberController.text.trim();

    if(name.isNotEmpty&&number.isNotEmpty){
      setState(() {
        _contacts.add({'name':name,'number':number});
      });
      _nameController.clear();
      _numberController.clear();
    }
  }

  ///this is the function for delete contract list
  void _deleteContact(int index){
    showDialog(context: context,
        builder:(BuildContext context){
          return  AlertDialog(
            title: const Text("Confirmation!!"),
            content: const Text("Are You Sure for delete??"),
            actions: [
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    _contacts.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center(
          child: Text(
            'Contact List',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey,
       // elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: 'Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
           const  SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addContact,
                child: Text('Add',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            const  SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        _contacts[index]['name']!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      subtitle: Text(
                        _contacts[index]['number']!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: IconButton(onPressed: () {},
                        icon:Icon(Icons.call, color: Colors.blue),
                      ),
                      onLongPress: () => _deleteContact(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

