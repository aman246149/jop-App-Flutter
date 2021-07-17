import 'package:flutter/material.dart';
import 'package:job/Reusable%20Components/TextFormCustom.dart';
import 'package:job/constant/constant.dart';

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
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Submitting")));
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: Text(
                      "Submit",
                      style: kmediumTextStyle,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
