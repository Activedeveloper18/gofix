import 'package:flutter/material.dart';
import 'package:goffix/screens/search/BookingDetailsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking_details_screen.dart'; 

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  List<Booking> bookingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final response = await http
        .get(Uri.parse('https://admin.goffix.com/api/booking/book.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        bookingList =
            jsonResponse.map((booking) => Booking.fromJson(booking)).toList();
        isLoading = false;
      });
    } else {
      // Handle the error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 80,
                    width: screenWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      "MY BOOKINGS",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.indigo,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                  itemCount: bookingList.length,
                  itemBuilder: (context, index) {
                    final booking = bookingList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsScreen(jobId: booking.jobId),
          ),
        );
      },
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.indigo,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  booking.serviceBookingDate.split(' ')[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Adjusted font size
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.white,
                                indent: 10.0,
                                endIndent: 10.0,
                              ),
                              Flexible(
                                child: Text(
                                  booking.serviceBookingDate.split(' ')[1],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Adjusted font size
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking.serviceName,
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Job ID #${booking.jobId}",
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              booking.workStatus,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'View',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
    );
  }
}

// models/booking_model.dart
class Booking {
  final String jobId;
  final String bookingDate;
  final String serviceBookingDate;
  final String serviceName;
  final String workStatus;

  Booking({
    required this.jobId,
    required this.bookingDate,
    required this.serviceBookingDate,
    required this.serviceName,
    required this.workStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      jobId: json['job_id'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      serviceBookingDate: json['service_booking_date'] ?? '',
      serviceName: json['service_name'] ?? '',
      workStatus: json['work_status'] ?? '',
    );
  }
}
