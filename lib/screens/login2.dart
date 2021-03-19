import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tendon_loader/utils/reusables.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _mUserCtlr = TextEditingController();
  TextEditingController _mPassCtlr = TextEditingController();
  AnimationController _mRotateCtlr;
  SharedPreferences _mPrefs;
  bool _mFirstRun;
  bool _mKeepMeLoggedIn = true;
  bool _mObscure = true;
  bool _mLegitimate = false;
  bool _isLoaded = false;

  @override
  void initState() {
    _initPrefs();
    Future.delayed(Duration(seconds: 2)).then((_) => setState(() => _isLoaded = true));
    _mRotateCtlr = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _mUserCtlr.dispose();
    _mPassCtlr.dispose();
    _mRotateCtlr.dispose();
    super.dispose();
  }

  Future<Null> _initPrefs() async {
    _mPrefs = await SharedPreferences.getInstance();
    setState(() {
      _mFirstRun = _mPrefs.getBool('F_RUN') ?? true;
      if (!_mFirstRun) {
        _mKeepMeLoggedIn = _mPrefs.getBool('KEEP') ?? false;
        if (_mKeepMeLoggedIn) {
          _mUserCtlr.text = _mPrefs.getString('USER') ?? '';
          _mPassCtlr.text = _mPrefs.getString('PASS') ?? '';
        }
      }
    });
  }

  Future<Null> _storePrefs(String pUser, String pPass, bool pKeep) async {
    if (_mFirstRun) await _mPrefs.setBool('F_RUN', pKeep ? false : true);
    await _mPrefs.setBool('KEEP', pKeep);
    await _mPrefs.setString('USER', pUser);
    await _mPrefs.setString('PASS', pPass);
  }

  Future<bool> _validate(String pUser, String pPass) async {
    // Login tLogin = await LoginDao().queryLogin(pUser, pPass) ?? null;
    // return null != tLogin ? tLogin.user == pUser && tLogin.pass == pPass : false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: _buildBody(context));
  }

  Container _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/screen_bg2.png'), fit: BoxFit.fill),
      ),
      child: Center(child: _isLoaded ? _buildContent(context) : Image.asset('assets/images/loading_01.gif')),
    );
  }

  SingleChildScrollView _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 3.0, color: Colors.deepOrange),
            ),
            child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blueAccent,
                child: ClipOval(child: Image.asset('assets/images/img_avatar3.jpg'))),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton.extended(
                  elevation: 0,
                  highlightElevation: 0,
                  label: Text(_mFirstRun ? 'Please Register below...' : 'Already registered...'),
                  icon: Icon(_mFirstRun ? Icons.add : Icons.check),
                  clipBehavior: Clip.none,
                  tooltip: 'Registration status...',
                  onPressed: () => _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(_mFirstRun ? 'New Registration...' : 'Congs!, You are already registered...'))),
                  backgroundColor: _mFirstRun ? Colors.red : Colors.blue)
            ],
          ),
          SizedBox(height: 20.0),
          _buildInputField(_mUserCtlr, '${_mFirstRun ? "New " : ""}Username',
              'Enter ${_mFirstRun ? "new" : ""} username...', Icons.person, false),
          SizedBox(height: 10.0),
          _buildInputField(_mPassCtlr, '${_mFirstRun ? "New " : ""}Password',
              'Enter ${_mFirstRun ? "new" : ""} password...', Icons.lock, true),
          SizedBox(height: 10.0),
          InkWell(
            borderRadius: mBorderRadiusBlBr,
            splashColor: Colors.blue,
            onTap: () => setState(() => _mKeepMeLoggedIn = !_mKeepMeLoggedIn),
            child: Container(
              decoration: BoxDecoration(borderRadius: mBorderRadiusBlBr, border: Border.all(width: 0.5)),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _mKeepMeLoggedIn,
                    onChanged: (newValue) => setState(() => _mKeepMeLoggedIn = newValue),
                  ),
                  Text('Keep me logged in.', style: TextStyle(color: Theme.of(context).accentColor))
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_mRotateCtlr),
                child: FloatingActionButton(
                  highlightElevation: 0.0,
                  elevation: 0.0,
                  heroTag: 'login_tag',
                  onPressed: () {
                    _mRotateCtlr.forward();
                    _validate(_mUserCtlr.text, _mPassCtlr.text).then((onBool) => _mLegitimate = onBool);
                    _mRotateCtlr.addListener(() {
                      if (_mRotateCtlr.status == AnimationStatus.completed) {
                        if (_mLegitimate) {
                          _mRotateCtlr.reset();
                          _mKeepMeLoggedIn
                              ? _storePrefs(_mUserCtlr.text, _mPassCtlr.text, true)
                              : _storePrefs('', '', false);
                          _mLegitimate = false;
                          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MyHomePage()));
                        } else {
                          _mRotateCtlr.reverse();
                          _mUserCtlr.clear();
                          _mPassCtlr.clear();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Hey...! Something is getting wrong...?')),
                          );
                        }
                      }
                    });
                  },
                  child: Icon(Icons.send),
                  backgroundColor: Colors.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextField _buildInputField(pCtlr, pLabel, pHint, pIcon, pObscure) {
    final Color _mAccentColor = Theme.of(context).accentColor;
    return TextField(
      cursorColor: _mAccentColor,
      controller: pCtlr,
      obscureText: pObscure ? _mObscure : false,
      onChanged: (_) => pObscure ? setState(() => _mObscure = true) : null,
      decoration: InputDecoration(
        labelText: pLabel,
        border: OutlineInputBorder(
            borderRadius: pObscure
                ? BorderRadius.zero
                : BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
        hintText: pHint,
        labelStyle: TextStyle(color: _mAccentColor),
        hintStyle: TextStyle(color: _mAccentColor),
        prefixIcon: Icon(pIcon, color: _mAccentColor),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            pObscure
                ? IconButton(
                    icon: Icon(_mObscure ? Icons.visibility_off : Icons.visibility),
                    color: _mAccentColor,
                    onPressed: () => setState(() => _mObscure = !_mObscure))
                : SizedBox(),
            IconButton(
              icon: Icon(Icons.clear, color: _mAccentColor),
              onPressed: () => setState(() => pObscure ? _mPassCtlr.clear() : _mUserCtlr.clear()),
            )
          ],
        ),
      ),
    );
  }
}
