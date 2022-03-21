import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFunction);

  final void Function(
          String email, String password, String username, bool isLogin)
      submitFunction;

  @override
  State<StatefulWidget> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isVisible = true;

  final _formKey = GlobalKey<FormState>();
  var _formFlipped = false;
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _tryLogin() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState?.save();
      widget.submitFunction(
        _userEmail, _userPassword, _userName, _isLogin
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade300,
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Container(),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    constraints: const BoxConstraints.expand(),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          _isLogin ? 'Log In' : 'Sign Up',
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          key: ValueKey('email'),
                          validator: (value) {
                            if (_formFlipped) return null;
                            if (emailController.text.isEmpty ||
                                !emailController.text.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          controller: emailController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            // icon: Icon(Icons.mail),
                            prefixIcon: const Icon(Icons.mail),
                            suffixIcon: emailController.text.isEmpty
                                ? const Text('')
                                : GestureDetector(
                                    onTap: () {
                                      emailController.clear();
                                    },
                                    child: const Icon(Icons.close)),
                            hintText: 'example@mail.com',
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                          onSaved: (value) {
                            _userEmail = value!;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('username'),
                            controller: usernameController,
                            onChanged: (value) {},
                            validator: (value) {
                              if (usernameController.text.isEmpty ||
                                  usernameController.text.length < 4) {
                                return 'Please enter username with at least 4 letters.';
                              }
                              return null;
                            },
                            //
                            decoration: InputDecoration(
                              // icon: Icon(Icons.mail),
                              prefixIcon: const Icon(Icons.person),
                              suffixIcon: usernameController.text.isEmpty
                                  ? const Text('')
                                  : GestureDetector(
                                      onTap: () {
                                        usernameController.clear();
                                      },
                                      child: const Icon(Icons.close)),
                              hintText: 'Enter your username',
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                            ),
                            onSaved: (value) {
                              _userName = value!;
                            },
                          ),
                        if (!_isLogin)
                          const SizedBox(
                            height: 16,
                          ),
                        TextFormField(
                          key: ValueKey('password'),
                          obscureText: isVisible,
                          controller: passwordController,
                          onChanged: (value) {},
                          validator: (value) {
                            if (passwordController.text.isEmpty ||
                                passwordController.text.length < 7) {
                              return 'Please enter password with at least 7 letters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            // icon: Icon(Icons.mail),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  isVisible = !isVisible;
                                  setState(() {});
                                },
                                child: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            hintText: 'Enter your password',
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                          onSaved: (value) {
                            _userPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (_isLogin)
                          ElevatedButton(
                            onPressed: _tryLogin,
                            child: const Text('Login'),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_isLogin) {
                                _isLogin = !_isLogin;
                              }
                            });

                            _tryLogin();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Text('Create new account'),
                          ),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (!_isLogin) {
                                _isLogin = !_isLogin;
                              }
                            });
                          },
                          child: Text(_isLogin
                              ? 'Forgot your password?'
                              : 'I have an account'),
                          style: TextButton.styleFrom(
                            primary: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
