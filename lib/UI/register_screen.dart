import 'package:commute/UI/widgets/register_form_widget.dart';
import 'package:commute/controller/a_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {

  final AController _controller = AController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: <Widget>[
            CustomPaint(size: Get.size, painter: CurvePainter()),
            Center(
                child: Padding(
              padding: EdgeInsets.only(bottom: Get.height * 0.3),
              child: CircleAvatar(
                radius: Get.height * 0.18,
              ),
            )),
            Center(
              child: SizedBox(
                width: Get.width * 0.6,
                height: Get.height * 0.3,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: RegisterFormWidget(),
                ),
              ),
            ),
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: Get.height * 0.3),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                elevation: 10,
                color: Colors.white,
                child: Text('submit'),
                onPressed: () async {
                 await _controller.setUser();
                 await _controller.registerUser();
                 Get.back();
                 Get.offAllNamed('/main');
                },
              ),
            ))
            // CircleAvatar(radius: Get.height * 0.4,)
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue[800];
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
