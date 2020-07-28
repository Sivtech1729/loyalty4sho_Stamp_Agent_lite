import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutterbarberagent/loading_screen.dart';
import 'dart:convert';

import 'package:http/http.dart';

class GiveLoyaltyPage extends StatefulWidget {
//  DocumentSnapshot agentData;
//  GiveLoyaltyPage(this.agentData);

  @override
  State<StatefulWidget> createState() {
    return _GiveLoyaltyPageState();
  }
}

class _GiveLoyaltyPageState extends State<GiveLoyaltyPage> {
  String points;
  String _qrInfo;
  bool _camState = false;

  List<CardType> _companies = CardType.getCompanies();
  List<DropdownMenuItem<CardType>> _dropdownMenuItems;
  CardType _selectedServiceCard;
  TextStyle normalTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
  Future<DocumentSnapshot> _documentSnapshot;
  bool isLoading = false;

  _qrCallback(String code) {
    setState(() {
      _camState = false;
      _qrInfo = code;
      getData(jsonDecode(code));
      // isLoading = true;
    });
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    scan();
    // _scanCode();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedServiceCard = _dropdownMenuItems[0].value;
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<CardType>> buildDropdownMenuItems(List lstServiceCard) {
    List<DropdownMenuItem<CardType>> items = List();
    for (CardType serviceCard in lstServiceCard) {
      items.add(
        DropdownMenuItem(
          value: serviceCard,
          child: Text(serviceCard.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(CardType selectedServiceCard) {
    setState(() {
      _selectedServiceCard = selectedServiceCard;
    });
  }

  Future<DocumentSnapshot> getData(userData) async {
    if (userData is Map && userData.containsKey("id")) {
      final DocumentSnapshot result = await Firestore.instance
          .collection('users')
          .document(userData['id'])
          .get();
      print('result:${result.exists}');
      if (result != null) {
        setState(() {
          _documentSnapshot = Future.value(result);
        });
        return _documentSnapshot;
      }
      // if(result != null) return result;
      return null;
    } else
      return null;
  }

  Future<DocumentSnapshot> getUserData(userData) async {
    if (userData is Map && userData.containsKey("id")) {
      final DocumentSnapshot result = await Firestore.instance
          .collection('users')
          .document(userData['id'])
          .get();
      print('result:${result.exists}');
      if (result != null) {
        return result;
      }
      // if(result != null) return result;
      return null;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Process Loyalty",
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: _camState
              ? Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.8, //- AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 20,
                    width: MediaQuery.of(context).size.width,
                    // child: scan()
                    // QRBarScannerCamera(
                    //   onError: (context, error) {
                    //     print(error.toString());
                    //     return Text(
                    //       error.toString(),
                    //       style: TextStyle(color: Colors.red),
                    //     );
                    //   },
                    //   qrCodeCallback: (code) {
                    //     _qrCallback(code);
                    //   },
                    // ),
                  ),
                )
              : _qrInfo == null
                  ? Center(
                      child: RaisedButton(
                        child: Text("Scan QR "),
                        onPressed: _scanCode,
                      ),
                    )
                  : FutureBuilder<DocumentSnapshot>(
                      future:
                          _documentSnapshot, //getUserData(jsonDecode(_qrInfo)),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData)
                          // Shows progress indicator until the data is load.
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent[700]),
                              ),
                            ),
                          );
                        // Shows the real data with the data retrieved.
                        else if (snapshot.hasData) {
                          DocumentSnapshot document = snapshot.data;
                          var response = document.data;
                          print('response:$response');

                          if (response != null)
                            return SingleChildScrollView(
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    height: size.height,
                                    width: size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Amount',
                                          style: normalTextStyle.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, bottom: 20),
                                          child: TextField(
                                            onChanged: (val) {
                                              points = val;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true,
                                                    decimal: true),
                                            decoration: InputDecoration(
                                                hintText: "200,00"),
                                          ),
                                        ),
                                        Text(
                                          'Service Type',
                                          style: normalTextStyle.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 20),
                                          child: Center(
                                            child: Container(
                                              // width: 200,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 1.0),
                                              ),
                                              child: Center(
                                                child: DropdownButtonFormField(
                                                  isExpanded: true,
                                                  value: _selectedServiceCard,
                                                  items: _dropdownMenuItems,
                                                  onChanged:
                                                      onChangeDropdownItem,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(0.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                                'Selected: ${_selectedServiceCard.name}')),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 10, left: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Client Details',
                                                style: normalTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: Text(
                                                      "Customer ID",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 2,
                                                    child: Text(
                                                      ":   ${response['CustID']}",
                                                      style:
                                                          normalTextStyle, //.copyWith(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: Text(
                                                      "Name",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 2,
                                                    child: Text(
                                                      ":   ${response['Name'] + " " + response['Surname']}",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: Text(
                                                      "Cell",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 2,
                                                    child: Text(
                                                      ":   ${response['cell']}",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: Text(
                                                      "Loyalty Points",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 2,
                                                    child: Text(
                                                      ":   ${response['Loyalty-Points']}",
                                                      style: normalTextStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              GestureDetector(
                                                child: Container(
                                                  height: 60,
                                                  color: Colors.black,
                                                  child: Center(
                                                    child: Text(
                                                      'Process'.toUpperCase(),
                                                      style: normalTextStyle
                                                          .copyWith(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  if (points != null) {
                                                    storeTransaction(
                                                        document, points);
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  height:
                                                      55.0, //size.height * .1,
                                                  // color: Colors.black,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 3.0)),
                                                  child: Center(
                                                    child: Text(
                                                      'Cancel'.toUpperCase(),
                                                      style: normalTextStyle
                                                          .copyWith(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          else
                            return Center(
                              child: RaisedButton(
                                child: Text("Scan QR "),
                                onPressed: _scanCode,
                              ),
                            );
                        } else {
                          return Center(
                            child: Text('Unable To Get Your Profile'),
                          );
                        }
                      },
                    ),
        ),
        Visibility(
          visible: isLoading,
          child: LoadingScreen(),
        ),
      ],
    );
  }

//  Widget processLoyalty() {
//    return Dialog(
//      child: Container(
//        padding: EdgeInsets.all(10),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            SizedBox(
//              height: 20,
//            ),
//            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//              Text(
//                "Give Loyalty Points",
//                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//              ),
//            ]),
//            SizedBox(
//              height: 10,
//            ),
//            Row(
//              children: <Widget>[
//                Text("Amount:"),
//                SizedBox(
//                  width: 15,
//                ),
//                Flexible(
//                    child: TextField(
//                      onChanged: (val) {
//                        points = val;
//                      },
//                      inputFormatters: <TextInputFormatter>[
//                        WhitelistingTextInputFormatter.digitsOnly
//                      ],
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(hintText: "200,00"),
//                    ))
//              ],
//            ),
//            SizedBox(
//              height: 20,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                RaisedButton(
//                  onPressed: () => Navigator.pop(context),
//                  child: Text(
//                    "Process",
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  color: Colors.black,
//                ),
//                RaisedButton(
//                  onPressed: () => Navigator.pop(context),
//                  child: Text(
//                    "Cancel",
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  color: Colors.black,
//                ),
//              ],
//            ),
//            SizedBox(
//              height: 20,
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  storeTransaction(DocumentSnapshot document, String point) async {
    try {
      String ctloyaltyCardName = "Loyalty_Card_${_selectedServiceCard.id}_ct";
      String stloyaltyCardName = "Loyalty_Card_${_selectedServiceCard.id}_st";
      var response = document.data;
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> loyaltyCardValues =
          calculateLoyaltyCardScores(response);
      await Firestore.instance
          .collection('users')
          .document(document.documentID)
          .updateData({
        "Transaction_Value": (response['Transaction_Value'] != null
            ? response['Transaction_Value'] + int.tryParse(points)
            : int.tryParse(points)),
        "Loyalty-Points": (response['Loyalty-Points'] != null
            ? response['Loyalty-Points'] + int.tryParse(points)
            : int.tryParse(points)),
        ctloyaltyCardName: loyaltyCardValues[ctloyaltyCardName],
        stloyaltyCardName: loyaltyCardValues[stloyaltyCardName]
      }).then((v) {
        Firestore.instance.collection('transactions').add({
          "User_Ref_Id": document.documentID,
          "Transac_Date": DateTime.now().millisecondsSinceEpoch,
          "Transac_Amount": int.tryParse(points),
          "Transac_Location":
              'JBH', //response['Name'] + " " + response['Surname'],
          "Transac_Card_Type": "${_selectedServiceCard.id}"
        }).then((v) {});
        Navigator.pop(context);
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> calculateLoyaltyCardScores(
      Map<String, dynamic> response) {
    String ctloyaltyCardName = "Loyalty_Card_${_selectedServiceCard.id}_ct";
    String stloyaltyCardName = "Loyalty_Card_${_selectedServiceCard.id}_st";
    Map<String, dynamic> loyaltyCardScores = Map();
    if (response[stloyaltyCardName] == 10) {
      loyaltyCardScores[stloyaltyCardName] = 0;
      loyaltyCardScores[ctloyaltyCardName] = response[ctloyaltyCardName] != null
          ? response[ctloyaltyCardName] + 1
          : 1;
    } else {
      loyaltyCardScores[stloyaltyCardName] = response[stloyaltyCardName] != null
          ? response[stloyaltyCardName] + 1
          : 1;
      loyaltyCardScores[ctloyaltyCardName] =
          response[ctloyaltyCardName] != null ? response[ctloyaltyCardName] : 0;
    }

    return loyaltyCardScores;
  }

  Future scan() async {
    try {
      var result = await BarcodeScanner.scan();

      setState(() {
        _camState = false;
        _qrInfo = result.toString();
        print(result.rawContent);
        getData(jsonDecode(result.rawContent));
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      // setState(() {
      //   scanResult = result;
      // });
    }
  }
}

class CardType {
  int id;
  String name;

  CardType(this.id, this.name);

  static List<CardType> getCompanies() {
    return <CardType>[
      CardType(1, 'Blow Dry'),
      CardType(2, 'Colour'),
      CardType(3, 'Product'),
      CardType(4, 'Gents'),
      CardType(5, 'Nails Card'),
    ];
  }
}
