import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class Connected extends StatefulWidget {

   final BluetoothDevice server;

   Connected({required this.server});
  @override
  _ConnectedState createState() => _ConnectedState();
}


class _ConnectedState extends State<Connected> {
  @override
  bool hasConnected = false;
  BluetoothConnection ?connection;
  bool get isConnected => (connection?.isConnected ?? false);
  void initState() {
    print("back at it");
    // TODO: implement initState

super.initState();
    BluetoothConnection.toAddress(widget.server.address.toString()).then((
        _address) =>
    {

      connection = _address,


      setState(() {
        hasConnected = true;
      }),



  //       if (this.mounted) {
  //   //      setState(()
  //
  // //        {})
  //
  //
  //           },
        //if(!_address){


        //}




    }).catchError((e) =>
    {
      print(e)
    });
    //super.initState();
  }
  bool pressed=false;
@override
  void dispose() {
    print("disposed");
    if(isConnected) {

      hasConnected = false;
      connection?.dispose();
    }
    // TODO: implement dispose
    super.dispose();
  }
  @override
  // bool _hasConnected=false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: hasConnected ? Text("Connected to your Car!") : Text(
            "Connecting"),
      ),
      floatingActionButton: hasConnected?FloatingActionButton(

           onPressed: ()async{

          !pressed?connection!.output.add(Uint8List.fromList(utf8.encode("Z"))):connection!.output.add(Uint8List.fromList(utf8.encode("z")));
          pressed=!pressed;
          await connection!.output.allSent;
           },


      ):null,
      body: hasConnected == true ? Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(

              child: Card(),

              width: MediaQuery.of(context).size.height*0.3,
                height: MediaQuery.of(context).size.height*0.5,
            ),

            GestureDetector(

                //BluetoothConnectio
                onTap: ()async{

                  connection!.output.add(Uint8List.fromList(utf8.encode("F")));
                  await connection!.output.allSent;


              },
              child: Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(child: Icon(Icons.arrow_upward)),
              ),
            ),

            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                  onTap: ()async{

                       connection!.output.add(Uint8List.fromList(utf8.encode("L")));
                               await connection!.output.allSent;

                  },





    child: Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(width: 40.0,),
                  GestureDetector(

                    onTap: ()async{

                      connection!.output.add(Uint8List.fromList(utf8.encode("R")));
                      await connection!.output.allSent;

                    },
                    child: Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(

              onTap: ()async{

                connection!.output.add(Uint8List.fromList(utf8.encode("D")));
                await connection!.output.allSent;

              },
              child: Container(

                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(Icons.arrow_downward),
              ),
            ),
          ],
        ),
      ) : Center(
        child: Container(
          //height: MediaQuery.of(context).size.height*0.2,
          child: CircularProgressIndicator(

          ),
        ),
      ),
    );
  }
}

//  void _sendMessage(String text) async {
//    text = text.trim();
//    textEditingController.clear();
//
//    if (text.length > 0) {
//      try {
//        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
//        await connection!.output.allSent;
//
//        setState(() {
//          messages.add(_Message(clientID, text));
//        });
//
//        Future.delayed(Duration(milliseconds: 333)).then((_) {
//          listScrollController.animateTo(
//              listScrollController.position.maxScrollExtent,
//              duration: Duration(milliseconds: 333),
//              curve: Curves.easeOut);
//        });
//      } catch (e) {
//        // Ignore error, but notify state
//        setState(() {});
//      }
//    }
//  }
// }

