import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedEventScreen extends StatefulWidget {
  const SelectedEventScreen();

  @override
  State<SelectedEventScreen> createState() => _SelectedEventScreenState();
}

class _SelectedEventScreenState extends State<SelectedEventScreen> {
  int count_tickts = 0;
  bool addbuttonclicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Tickets"),
      ),
      body: Center(
          child: Column(
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
        Expanded(
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context,index){
            return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width:200,
                          child: Text(
                              'General Entry for Adults for kids (6-11)yrs\n\u{20B9} 1000'),
                        ),
                        addbuttonclicked?  Container(
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                if(count_tickts<10){
                                  count_tickts++;
                                }
                                setState(() {
          
                                });
                              }, icon: Icon(Icons.add)),
                              Text("$count_tickts",style: Theme.of(context).textTheme.bodyLarge,),
                              IconButton(onPressed: (){
                                if(count_tickts>0){
                                  count_tickts--;
                                }
                                setState(() {
          
                                });
                              }, icon: Icon(Icons.remove)),
          
                            ],
                          ),
                        ):ElevatedButton(
                          onPressed: () {
                            addbuttonclicked = true;
                            setState(() {
          
                            });
                          },
                          child: Text(
                            "ADD",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Text(
                      'Here’s how you can modify your SelectedEventScreen widget to work with older versions of Flutter',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

          SizedBox(
            width: MediaQuery.of(context).size.width*0.85,
            child: ElevatedButton(
              onPressed: () {
                addbuttonclicked = true;
                setState(() {

                });
              },
              child: Text(
                "Continue",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
        ],
      )),
    );
  }
}
