import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leoam/common/global.dart';
import 'package:leoam/common/UserModel.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('loginPage.appbar_text'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: _nameAutoFocus,
                  controller: _unameController,
                  decoration: InputDecoration(
                    labelText: tr('loginPage.userName'),
                    hintText: tr('loginPage.userNameOrEmail'),
                    prefixIcon: Icon(Icons.person),
                  ),
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v.trim().isNotEmpty
                        ? null
                        : tr('loginPage.userNameRequired');
                  }),
              TextFormField(
                controller: _pwdController,
                autofocus: !_nameAutoFocus,
                decoration: InputDecoration(
                    labelText: tr('loginPage.password'),
                    hintText: tr('loginPage.password'),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty
                      ? null
                      : tr('loginPage.passwordRequired');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text(tr('loginPage.appbar_text')),
                  ),
                ),
              ),
              Text("name:${context.watch<UserModel>().lastLogin}")
            ],
          ),
        ),
      ),
    );
  }

  void onAuthSuccess(Map<String, dynamic> event) {
    Global.profile.authSuccess(_unameController.text, _pwdController.text);
  }

  void _onLogin() async {
    //1.将认证信息保存

    var authInfo = Map<String, String>();
    authInfo["token"] = _pwdController.text;
    authInfo["uid"] = _unameController.text;
    Global.netMgr.setMsgCallBack("onAuthSuccess", onAuthSuccess);
    Global.netMgr.sendMsgToGate(jsonEncode(authInfo));
  }
}
