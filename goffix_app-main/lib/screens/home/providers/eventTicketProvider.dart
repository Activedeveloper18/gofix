import 'package:flutter/material.dart';
import 'package:goffix/screens/home/data/eventTicketData.dart';
import 'package:goffix/screens/home/models/eventTicketPageModel.dart';
import 'package:provider/provider.dart';

class EventTicketProvider with ChangeNotifier {
  List<EventTicketItem> list = [];
  List<bool> isClicked = [];
  List<TextEditingController> myTextListController = [];
  getAllTicketsData(String id) async {
    String ticketRawData = await EventTicketData.getEventTickets(id);
    var ticketsData = eventTicketPageModelFromJson(ticketRawData);
    list.clear();
    isClicked.clear();
    for (int i = 0; i < ticketsData.response!.result!.data!.length; i++) {
      list.add(EventTicketItem(
        etId: ticketsData.response!.result!.data![i].etId,
        etAddsAId: ticketsData.response!.result!.data![i].etAddsAId,
        ticketPrice: ticketsData.response!.result!.data![i].ticketPrice,
        ticketCount: ticketsData.response!.result!.data![i].ticketCount,
        ticketPriceInfo: ticketsData.response!.result!.data![i].ticketPriceInfo,
        date: ticketsData.response!.result!.data![i].date,
      ));
      isClicked.add(false);
    }
    notifyListeners();
  }

  void addClick(int index) {
    isClicked[index] = true;
    myTextListController.add(TextEditingController());

    notifyListeners();
  }

  // void qtyCounterClick(int index) {
  //   myTextListController[index] = TextEditingController();
  //   notifyListeners();
  // }
}
