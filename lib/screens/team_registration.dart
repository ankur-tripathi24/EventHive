import 'package:eventhive/service/database.dart';
import 'package:flutter/material.dart';

class TeamRegistrationForm extends StatefulWidget {
  Map<String, dynamic> data = {};
  TeamRegistrationForm({super.key, required this.data});

  @override
  _TeamRegistrationFormState createState() => _TeamRegistrationFormState();
}

class _TeamRegistrationFormState extends State<TeamRegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _teamName;
  late final TextEditingController _numberOfMembers;
  List<MemberInfo> members = [MemberInfo()];
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    print(widget.data['id']);
    _teamName = TextEditingController();
    _numberOfMembers = TextEditingController();
    _numberOfMembers.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _teamName.dispose();
    _numberOfMembers.dispose();
    super.dispose();
  }

  void _addMember() {
    setState(() {
      members.add(MemberInfo());
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        List<String> _ids = [];
        List<String> emails = [];
        members.forEach((member) {
          emails.add(member.email);
        });
        await databaseService.getUserIds(emails).then((value) {
          _ids = value;
        });
        await databaseService.registerTeam(
          _teamName.text,
          _ids,
          widget.data['id'],
        );

        await databaseService.makeRegisterForHackathonTrue(
            _ids, widget.data['id']);

        print('Successful registration');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/dashboard', (route) => false);
      } catch (e) {
        print(e);
      }

      // Form validation successful, you can save the data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Registration'),
        backgroundColor: const Color(0xFF176B87),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10.0),
        //     border: Border.all(width: 1.0, color: Colors.black)),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Team Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
                controller: _teamName,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Members'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number of members';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    members = List.generate(
                        int.parse(value), (index) => MemberInfo());
                  });
                },
                controller: _numberOfMembers,
              ),
              for (int i = 0; i < int.parse(_numberOfMembers.text); i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Member ${i + 1}'),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onSaved: (value) {
                        members[i].name = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        members[i].email = value!;
                      },
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF176B87),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberInfo {
  String name = '';
  String email = '';
}
