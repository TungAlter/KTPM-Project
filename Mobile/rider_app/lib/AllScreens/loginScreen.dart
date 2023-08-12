import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:rider_app/AllScreens/registerationScreen.dart";
import "package:rider_app/Allwidgets/progressDialog.dart";
import "package:rider_app/main.dart";
import "package:rider_app/AllScreens/mainscreen.dart";
import "package:fluttertoast/fluttertoast.dart";

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //!khung chứa giao diện mainscreen
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //!cho phép cuộn trên giao diện
        child: Padding(
          //!khoảng cách (padding) xung quanh nội dung bên trong của nó.
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //! Các thành phần như logo,phần nhập nội dung sẽ được tổ chức theo từng dòng
            children: [
              const SizedBox(
                //!khoản cách giữa các thành phần giao diện
                height: 35.0,
              ),
              const Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              const SizedBox(
                //!khoản cách giữa các thành phần giao diện
                height: 1.0,
              ),
              const Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                //!khoảng cách (padding) xung quanh nội dung bên trong của nó.
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  //! Các thành phần như logo,phần nhập nội dung sẽ được tổ chức theo từng dòng
                  children: [
                    //!Email
                    const SizedBox(
                      //!khoản cách giữa các thành phần giao diện
                      height: 1.0,
                    ),
                    TextField(
                      //! phần điền input
                      controller:
                          emailTextEditingController, //!lắng nghe và xử lý giá trị
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    //!pass
                    const SizedBox(
                      //!khoản cách giữa các thành phần giao diện
                      height: 1.0,
                    ),
                    TextField(
                      //! phần điền input
                      controller:
                          passwordTextEditingController, //!lắng nghe và xử lý giá trị
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      //!khoản cách giữa các thành phần giao diện
                      height: 10.0,
                    ),
                    ElevatedButton(
                      //!nút đăng nhập
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          //!email không hợp lệ
                          displayToastMessage(
                              "Email address is invalid", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          //!để trống
                          displayToastMessage("Password is mandatory", context);
                        } else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.yellow,
                        textStyle: const TextStyle(
                            fontSize: 18.0, fontFamily: "iA Writter Mono S"),
                        minimumSize: const Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      //! nút route sang trang đăng ký
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RegisterationScreen.idScreen, (route) => false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                            fontSize: 13.0, fontFamily: "Brand Bold"),
                      ),
                      child:
                          const Text("Do not have an Account ? Register here"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const ProgressDialog(message: "Authenticating,Please wait...");
        });

    try {
      final UserCredential authResult =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      );

      final User? firebaseUser = authResult.user;

      if (firebaseUser != null) {
        var snapshot = await userRef.child(firebaseUser.uid).once();
        if (snapshot.snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are logged-in now", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "No record exists for this user. Please create a new account.",
              context);
        }
      } else {
        //Navigator.pop(context);
        displayToastMessage(
            "Error when logging in. Please try again.", context);
      }
    } catch (e) {
      Navigator.pop(context);
      displayToastMessage("ERROR: $e", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    //Navigator.pop(context);
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}
