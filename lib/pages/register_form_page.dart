import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form/model/user.dart';
import 'package:flutter_form/pages/user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;
  bool _hideConfirmedPass = true;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isEmailEmpty = true;

  List<String> _countries = ['Russia', 'Ukraine', 'Germany', 'France'];
  String? _selectedCountry;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final _passConFocus = FocusNode();

  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    _passConFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register Form'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              TextFormField(
                focusNode: _nameFocus,
                autofocus: true,
                onFieldSubmitted: (_) {
                  _fieldFocusChange(context, _nameFocus, _phoneFocus);
                },
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'What do people call you?',
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _nameController.clear();
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                validator: _validateName,
                onSaved: (value) => newUser.name = value!,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: _phoneFocus,
                onFieldSubmitted: (_) {
                  _fieldFocusChange(context, _phoneFocus, _passFocus);
                },
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: 'Where can we reach you?',
                  helperText: 'Phone format: (XXX)XXX-XXXXX',
                  prefixIcon: Icon(Icons.call),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _phoneController.clear();
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  //FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter(RegExp(r'[\d\(\)\-]'),
                      allow: true),
                ],
                validator: (value) => _validatePhoneNumber(value)
                    ? null
                    : 'Phone number must be entered as (XXX)XXX-XXXXX',
                onSaved: (value) => newUser.phone = value,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {
                      _isEmailEmpty = value.isEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email Address ',
                    hintText: 'Enter a email adress',
                    icon: Icon(Icons.mail),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  //validator: _validateEmail,

                  onSaved: (value) => newUser.email = value),
              SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.map),
                  labelText: 'Country?',
                ),
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    child: Text(country),
                    value: country,
                  );
                }).toList(),
                onChanged: (country) {
                  print(country);
                  setState(() {
                    _selectedCountry = country!;
                    newUser.country = country;
                  });
                },
                value: _selectedCountry,
                // validator: (val) {
                //   return val == null ? 'Please select a country' : null;
                // },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _storyController,
                decoration: InputDecoration(
                  labelText: 'Life Story ',
                  hintText: 'Tell us about yourself',
                  helperText: 'Keep it short, this is just a demo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                onSaved: (value) => newUser.story = value,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: _passFocus,
                onFieldSubmitted: (_) {
                  _fieldFocusChange(context, _passFocus, _passConFocus);
                },
                controller: _passwordController,
                obscureText: _hidePass,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  hintText: 'Enter the Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _hidePass ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    },
                  ),
                  icon: Icon(Icons.security),
                ),
                validator: _validatePassword,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: _passConFocus,
                controller: _confirmPassController,
                obscureText: _hideConfirmedPass,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: 'Confirm Password *',
                  hintText: 'Confirm the Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirmedPass
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideConfirmedPass = !_hideConfirmedPass;
                      });
                    },
                  ),
                  icon: Icon(Icons.border_color),
                ),
                validator: _validatePassword,
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: _submitForm,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    'Submit Form',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          )),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Form submitted successfully',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: Duration(seconds: 4),
        ),
      );
      _showDialog(name: _nameController.text);
      print('Name: ${_nameController.text}');
      print('Phone:${_phoneController.text}');
      print('Email:${_emailController.text}');
      print('Story:${_storyController.text}');
      print('Country:$_selectedCountry');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please correct the errors in the form',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: Duration(seconds: 4),
        ),
      );
      print('Form is not valid! Please review and correct');
    }
  }

  String? _validateName(String? value) {
    final _nameExp = RegExp(r'^[A-Za-z ]+$');
    if (value == null || value.isEmpty) {
      return 'Name is required.';
    } else if (!_nameExp.hasMatch(value)) {
      return 'Please enter alphabetical characters.';
    }
    return null;
  }

  bool _validatePhoneNumber(String? input) {
    final _phoneExp = RegExp(r'^\(\d{3}\)\d{3}\-\d{5}$');
    return _phoneExp.hasMatch(input ?? '');
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!value.contains('@')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (_passwordController.text.length != 8) {
      return '8 characters required for password';
    } else if (_confirmPassController.text != _passwordController.text) {
      return 'Password doese not match';
    } else {
      return null;
    }
  }

  void _showDialog({String? name}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Registration successful',
              style: TextStyle(color: Colors.green),
            ),
            content: Text(
              '$name is now a verified register form',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoPage(
                            userInfo: newUser,
                          ),
                        ));
                  },
                  child: Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                    ),
                  ))
            ],
          );
        });
  }
}
