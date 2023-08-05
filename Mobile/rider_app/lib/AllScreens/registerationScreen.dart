import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:rider_app/AllScreens/loginScreen.dart";
import "package:rider_app/AllScreens/mainscreen.dart";
import "package:rider_app/main.dart";
import "package:rider_app/Allwidgets/progressDialog.dart";

class RegisterationScreen extends StatelessWidget {
  RegisterationScreen({Key? key}) : super(key: key);
  static const String idScreen = "register";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              const Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 1.0,
              ),
              const Text(
                "Register as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //!name
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Name",
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
                    //!Email
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
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
                    //!Phone
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone",
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
                      height: 1.0,
                    ),
                    //!Pass
                    TextField(
                      controller: passwordTextEditingController,
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
                      height: 1.0,
                    ),
                    //!button
                    ElevatedButton(
                      onPressed: () {
                        if (nameTextEditingController.text.length < 4) {
                          displayToastMessage(
                              "name must be at least 3 characters", context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not valid", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Phone Number is mandatory", context);
                        } else if (passwordTextEditingController.text.length <
                            7) {
                          displayToastMessage(
                              "Password must be at least 7 characters",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.yellow,
                        textStyle: const TextStyle(
                            fontSize: 18.0, fontFamily: "Brand Bold"),
                        minimumSize: const Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      child: const Text("Create Account"),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LoginScreen.idScreen, (route) => false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                            fontSize: 13.0, fontFamily: "Brand Bold"),
                      ),
                      child: const Text("Already have an Account ? Login here"),
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

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const ProgressDialog(message: "Registering,Please wait...");
        });

    try {
      final UserCredential authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      );

      final User? firebaseUser = authResult.user; // Xóa "!" ở đây

      if (firebaseUser != null) {
        // Đăng ký thành công, bạn có thể thực hiện các tác vụ tiếp theo ở đây.
        // Ví dụ: chuyển hướng đến trang chính của ứng dụng
        Map<String, dynamic> userDataMap = {
          // Thêm kiểu dữ liệu cho userDataMap
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
        };
        userRef.child(firebaseUser.uid).set(userDataMap);
        displayToastMessage("Your account has been created.", context);
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.idScreen, (route) => false);
      } else {
        // Nếu firebaseUser là null, có thể xảy ra lỗi trong quá trình đăng ký.
        // Hãy xử lý lỗi ở đây (hiển thị thông báo lỗi, đăng nhập lại, vv.).
        displayToastMessage("Error when create,please try again.", context);
      }
    } catch (e) {
      // Nếu có lỗi xảy ra trong quá trình đăng ký, sẽ nằm trong biến e.
      // Xử lý lỗi ở đây (hiển thị thông báo lỗi, đăng nhập lại, vv.).
      Navigator.pop(context);
      displayToastMessage("ERROR: $e", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    //Navigator.pop(context);
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}
