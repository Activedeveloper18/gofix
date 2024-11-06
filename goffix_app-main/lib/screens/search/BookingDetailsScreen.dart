import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String jobId;

  const BookingDetailsScreen({Key? key, required this.jobId}) : super(key: key);

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Map<String, dynamic>? bookingData;
  bool isLoading = true;
  int selectedStars = 0; // Variable for star rating
  Map<String, bool> ratingCriteria = {
    "Service Quality": false,
    "Time Management": false,
    "Professionalism": false,
    "Communication": false,
    "Value for money": false,
  };

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  Future<void> fetchBookingDetails() async {
    final response = await http.get(
      Uri.parse('https://admin.goffix.com/api/booking/book.php?job_id=${widget.jobId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        bookingData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load booking details')),
      );
    }
  }

  Future<void> submitBookingDetails() async {
    final response = await http.put(
      Uri.parse('https://admin.goffix.com/api/booking/book.php'),
      body: json.encode({
        'job_id': widget.jobId,
        'fixer_rating': selectedStars,
        'criteria': ratingCriteria,
        'review_text': bookingData?["review_text"] ?? '',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    // if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking details submitted successfully')),
      );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to submit booking details')),
    //   );
    // }
  }

  void _launchCaller() async {
    final phoneNumber = bookingData?["phone_number"] ?? ''; // Update with actual field name
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job Details Section
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailColumn("Job Id", bookingData!["job_id"].toString()),
                                    _buildDetailColumn("Service", bookingData!["service_name"] ?? ''),
                                    _buildDetailColumn("Status", bookingData!["work_status"] ?? ''),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),

                              // Contact Icons Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: _launchCaller,
                                    child: Icon(Icons.call, size: 30),
                                  ),
                                  Icon(Icons.access_time, size: 30),
                                  Icon(Icons.cancel, size: 30),
                                  Icon(Icons.message, size: 30),
                                ],
                              ),
                              SizedBox(height: 16),

                              // Order Details Section
                              _buildOrderDetailsSection(),
                              SizedBox(height: 16),

                              // Rating Section
                              _buildRatingSection(),
                            ],
                          ),
                        ),
                      ),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: submitBookingDetails,
                          child: Text("SUBMIT", style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: Text('No booking details available')),
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOrderDetailsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20),
              SizedBox(width: 8),
              Text(bookingData!["service_booking_date"] ?? ''),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 20),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  bookingData!["location"] ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clickable star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStars = index + 1;
                  });
                },
                child: Icon(
                  Icons.star,
                  color: index < selectedStars ? Colors.amber : Colors.grey,
                  size: 30,
                ),
              );
            }),
          ),
          SizedBox(height: 16),

          // Rating criteria checkboxes
          ...ratingCriteria.keys.map((label) {
            return CheckboxListTile(
              title: Text(label),
              value: ratingCriteria[label],
              onChanged: (value) {
                setState(() {
                  ratingCriteria[label] = value ?? false;
                });
              },
            );
          }).toList(),

          SizedBox(height: 16),

          // Review Text
          TextFormField(
            initialValue: bookingData!["review_text"],
            maxLines: 3,
            onChanged: (value) => bookingData!["review_text"] = value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Review",
            ),
          ),
        ],
      ),
    );
  }
}
