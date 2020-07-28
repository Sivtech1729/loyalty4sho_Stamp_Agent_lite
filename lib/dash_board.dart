import 'package:flutter/material.dart';
import 'package:flutterbarberagent/drawer.dart';
import 'package:flutterbarberagent/give_loyalty.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class DashBoard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        elevation: 0,
        title: Text(
          'Pay Loyalty',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: drawerWidget(context),
      body: Container(
          color: Colors.blueAccent[700],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                        margin: EdgeInsets.only(top: 40),
                        width: 250,
                        height: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.moneyBillAlt),
                                SizedBox(
                                  width:
                                  30,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GiveLoyaltyPage()));
                                  },
                                  child: Container(
                                    height: 90,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent[700],
                                      borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Earn Loyalty',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),),
                                          Text('Process for customer to earn loyalty',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.wallet),
                                SizedBox(
                                  width:
                                  30,
                                ),
                                Container(
                                  height: 90,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent[700],
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Use Voucher',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                        Text('Use to process voucher',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: CircleAvatar(
                          child: Text(
                            "Logo",
                          ),
                          radius: 35,
                          backgroundColor: Colors.black,
                        ),
                        alignment: Alignment.center,
                      )
                    ])
              ]
          )
      ),
    );
  }
}