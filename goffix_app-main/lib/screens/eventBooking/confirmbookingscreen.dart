import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/eventBooking/paymentsuccessScreen.dart';

class Confirmbookingscreen extends StatefulWidget {
  const Confirmbookingscreen();

  @override
  State<Confirmbookingscreen> createState() => _ConfirmbookingscreenState();
}

class _ConfirmbookingscreenState extends State<Confirmbookingscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Booking"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(

              children: [
              Text(
                'New Year 2025 ShopperStop Mall & Music',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Text(
                '31 December 2025',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Text(
                'Here’s how you can modify your SelectedEventScreen widget to work with older versions of Flutter',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              10.verticalSpace,
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)),
                padding: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                                'General Entry  for kids (6-11)yrs'),
                          ),

                          Text(
                            "2 Tickets",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                                'General Entry for Adults'),
                          ),

                          Text(
                            "2 Tickets",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              Container(

                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)),
                padding: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'SLB Total',style: TextStyle(fontWeight: FontWeight.w700),),
                            Text(
                                '350.00',style: TextStyle(fontWeight: FontWeight.w700),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(
                            width: 200,
                            child: Text(
                                'Discount'),
                          ),

                          Text(
                            "0.00",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                                'GST'),
                          ),

                          Text(
                            "15.00",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(thickness: 1,color: Colors.black12,),
                      Text(
                        "*apply Terms & Conditions",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black),
                      ),

                    ],
                  ),
                ),
              ),

            ],),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Paymentsuccessscreen()));
                },
                child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
