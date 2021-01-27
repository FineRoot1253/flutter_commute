import 'package:commute/controller/a_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterFormWidget extends StatelessWidget {

  final AController _controller = AController.to;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Register",style: TextStyle(fontSize: 18.0),),
          ),
          Container(
            width: Get.width*0.5,
            height: Get.height*0.2,
            child: TextFormField(
              controller: _controller.registerFormController,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                  labelText: '이름',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12,width: 3.0)),
                  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 3.0))
                )),
          )
        ],
      ),
    );
  }
}
