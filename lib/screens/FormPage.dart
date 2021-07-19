import 'package:flutter/material.dart';
import 'package:job/Reusable%20Components/TextFormCustom.dart';
import 'package:job/constant/constant.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
// flutter toast
import 'package:fluttertoast/fluttertoast.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>(); //formkey for validation

  // creating controller to capture data from text form fields

  TextEditingController companyNameController = new TextEditingController();
  TextEditingController degreeController = new TextEditingController();
  TextEditingController positionController = new TextEditingController();
  TextEditingController sourceController = new TextEditingController();

// creating a loading variable
  bool isLoading = false;
  bool isSuccess = false;

  // creating time variable

  final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 10));

// Create a CollectionReference called users that references the firestore collection
  CollectionReference companydata =
      FirebaseFirestore.instance.collection('companyData');

  Future<void> companydatafunction() {
    // Call the user's CollectionReference to add a new user
    return companydata.add({
      'company_name': companyNameController.text.toString(), // John Doe
      'degree_required': degreeController.text.toString(), // Stokes and Sons
      'position': positionController.text.toString(), // 42
      'source': sourceController.text.toString(), // 42
      'time': findYearAndMonth(),
      'timeStamp': Timestamp.now(),
    }).then((value) {
      setState(() {
        isLoading = false;
        isSuccess = true;
        companyNameController.text = "";
        degreeController.text = "";
        positionController.text = "";
        sourceController.text = "";
      });
    }).catchError((error) {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Job Posting Page",
            style: kAppBarStyle,
          )),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormCustom(
                controller: companyNameController,
                lablename: "Company Name",
              ),
              TextFormCustom(
                controller: degreeController,
                lablename: "Degree Required",
              ),
              TextFormCustom(
                controller: positionController,
                lablename: "which position",
              ),
              TextFormCustom(
                controller: sourceController,
                lablename: "enter source where you get this info",
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: IgnorePointer(
                  ignoring: isLoading,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            FocusScope.of(context)
                                .requestFocus(FocusNode()); //hide keyboard

                            isLoading = true;
                          });
                          await companydatafunction();

                          if (isSuccess) {
                            Fluttertoast.showToast(
                                msg: "Data Added SuccessFully",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.deepPurple,
                                textColor: Colors.white,
                                fontSize: 20.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Error comes",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.deepPurple,
                                textColor: Colors.white,
                                fontSize: 20.0);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      child: Text(
                        "Submit",
                        style: kmediumTextStyle,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
