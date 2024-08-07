import "package:flutter/material.dart";

popMessage(context,message){
  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    margin: EdgeInsets.symmetric(vertical: 300),
    behavior: SnackBarBehavior.floating,
    content:Text('$message'),
    action: SnackBarAction(

      label: 'Undo',
      onPressed: () {
        // Code to execute when the "Undo" action is pressed
      },
    ),
  );

  // Use ScaffoldMessenger to show the Snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}