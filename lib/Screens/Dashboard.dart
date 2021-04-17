import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_app/Models/Wifi.dart';
import 'package:wifi_app/Widget/Diaglogue.dart';
import 'package:wifi_app/Widget/Field.dart';
import 'package:wifi_flutter/wifi_flutter.dart';

//This is the main Dashboard
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // Every text field required a TextEditing Cotroller to control whats going on in the field like field text etc
  TextEditingController wifiController;
  TextEditingController signalStrengthController;
  bool isLoading = false;
  Directory _downloadsDirectory;

  List<Widget> _platformVersion = [];

  List<List<dynamic>> rowscsv = List<List<dynamic>>();
  List<dynamic> rows = List<dynamic>();

  //This is the init method of the widget class it will run when the class will be created one time so in this method you should
  //put all the logic that is required before the widget get created for example i have initialized the Text editing controllers
  //in this method becuase i needed them before the creation of widgets
  @override
  void initState() {
    super.initState();
    wifiController = TextEditingController();
    signalStrengthController = TextEditingController();
    localpath();
  }

//This is dispose method in which you should dispose anything when the widget gets destroyed to stop any memory leakage
//As these controller must be disposed from memory to save memory leakage
  @override
  void dispose() {
    wifiController.dispose();
    signalStrengthController.dispose();
    super.dispose();
  }

  Future<void> localpath() async{

    await Permission.storage.request();

      Directory downloadsDirectory;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      } on PlatformException {
        print('Could not get the downloads directory');
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        _downloadsDirectory = downloadsDirectory;
      });

  }

  @override
  Widget build(BuildContext context) {
    //This line is to get the size of the screen to make the application responsive
    Size size = MediaQuery.of(context).size;
//These are your standard build method in which there are only widgets which are on the screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Wifi Guidance'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () async {

                final noPermissions = await WifiFlutter.promptPermissions();
                if (noPermissions) {
                  return;
                }
                final networks = await WifiFlutter.wifiNetworks;
                setState(() {

                  networks.map((e) => rowscsv.add(
                    [
                      e.ssid,e.rssi,e.isSecure
                    ]
                  )).toList();

                  _platformVersion = networks.map((network) => Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        Wrap(
                          children: [
                            Icon(
                              Icons.wifi,color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Text(network.ssid,style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                network.isSecure?Text("Secure",textAlign: TextAlign.start,):Text("Not Secure",textAlign: TextAlign.start),
                              ],
                            ),
                          ],
                        ),
                        Text("Strength"+network.rssi.toString())
                      ],
                    ),
                  )).toList();


                });
                // "Ssid ${network.ssid} - Strength ${network.rssi} - Secure ${network.isSecure}")

                print(rowscsv);
              })
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Field(
              hintText: 'Wifi Name',
              icon: Icons.wifi,
              controller: wifiController,
            ),
            SizedBox(
              height: 10,
            ),
            Field(
              hintText: 'Signal Strength',
              icon: Icons.signal_cellular_alt,
              controller: signalStrengthController,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, i) => _platformVersion[i],
                itemCount: _platformVersion.length,
              ),
            ),

            SizedBox(
              height: size.height * 0.075,
              width: size.width * 0.9,
              child: RaisedButton(
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Export CSV',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                color: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                //This is the main function you should be concerned about
                onPressed: () async {


                  await Permission.storage.request();



                  String getpath = _downloadsDirectory.path+"/filename.csv";

                  print(" FILE " + getpath);

                  File f = new File(getpath);

                  String csv = const ListToCsvConverter().convert(rowscsv);

                  print(csv);

                  f.writeAsString(csv);




                  // final directory = await getApplicationDocumentsDirectory();
                  // final pathOfTheFileToWrite = directory.path + "/myCsvFile.csv";
                  // File file = await File(pathOfTheFileToWrite);
                  // file.writeAsString(csv);





                  // //These are standard checks using text field controllers like if the filed is empty or it has incorect value then it will pop up an error
                  // if (wifiController.text.isEmpty ||
                  //     signalStrengthController.text.isEmpty) {
                  //   Dialogues.showErrorToast('Please Provide Wifi details');
                  // } else if (double.parse(
                  //         signalStrengthController.text.trim()) >
                  //     100) {
                  //   Dialogues.showErrorToast('Please Between 0 to 100');
                  // } else {
                  //   //If you complete the validation then this function will run in which you are adding the wifi to firebase
                  //   //As the firebase querry is asynchoronus it will take time to get respond so here is a helper variable to show some loading
                  //   setState(() {
                  //     isLoading = true;
                  //   });
                  //   //This is the firebase request, you get the firbase instance first then you to to approperiate collection that is here wifi
                  //   //and then you add the desired document here you are adding two values in one document
                  //   FirebaseFirestore.instance.collection('wifi').add(Wifi(
                  //           wifiName: wifiController.text.trim(),
                  //           signalStrength: double.parse(
                  //               signalStrengthController.text.trim()))
                  //       .toMap());
                  //
                  //   //After the request loading state is return to false
                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  //
                  //   //Pop to show user their request has been completed and also clear the text from fields
                  //   Dialogues.showToast('Successfully Added in Firebase');
                  //   wifiController.clear();
                  //   signalStrengthController.clear();
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
