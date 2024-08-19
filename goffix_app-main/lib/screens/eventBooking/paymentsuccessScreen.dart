import 'package:flutter/material.dart';
import 'package:goffix/screens/layout/layout.dart';

class Paymentsuccessscreen extends StatefulWidget {
  const Paymentsuccessscreen();

  @override
  State<Paymentsuccessscreen> createState() => _PaymentsuccessscreenState();
}

class _PaymentsuccessscreenState extends State<Paymentsuccessscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Layout()));

          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                height: 400,width: 300,
                child: Image.asset("assets/images/paymentsuccess.gif",fit: BoxFit.fitHeight,)),
            Text("Booked ",style: TextStyle(fontSize: 50),)
          ],
        ),
      ),
    );
  }
}
