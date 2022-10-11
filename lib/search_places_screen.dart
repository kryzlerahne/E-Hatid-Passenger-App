import 'package:ehatid_passenger_app/place_prediction_tile.dart';
import 'package:ehatid_passenger_app/predicted_places.dart';
import 'package:ehatid_passenger_app/request_assistant.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPlacesScreen extends StatefulWidget
{

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen>
{
  List<PredictedPlaces> placesPredictedList =[];

  void findPlaceAutoCompleteSearch(String inputText) async
  {
    if (inputText.length > 1) //2 or more than 2 input characters
      {
        String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io&components=country:PH";

        var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

        if(responseAutoCompleteSearch == "Error occured, Failed. No response.")
          {
            return;
          }

        if(responseAutoCompleteSearch["status"] == "OK")
          {
            var placesPredictions = responseAutoCompleteSearch["predictions"];

           var placePredictionsList = (placesPredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

           setState(() {
             placesPredictedList = placePredictionsList;
           });
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBE5D8),
      body: Column(
        children: [
          //search place UI
          Container(
            height: Adaptive.h(21),
            decoration: BoxDecoration(
              color: Color(0xFFFED90F),
              boxShadow:
                [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7
                    )
                  ),
                ],
            ),
            child: Padding(
              padding: EdgeInsets.all(Adaptive.h(1)),
              child: Column(
                children: [
                  SizedBox(height: Adaptive.h(4),),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Search and Set DropOff Location",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 18.sp,
                              letterSpacing: -1,
                              fontWeight: FontWeight.bold),
                          //textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Adaptive.h(1),),
                  Row(
                    children: [
                      Icon(
                        Icons.adjust_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(width: Adaptive.h(3),),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextField(
                            onChanged: (valueTyped)
                            {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFFED90F),),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: "Search here...",
                                hintStyle: TextStyle( color: Color(0xbc000000),
                                  fontSize: 15,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,),
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: Icon(Icons.storefront,  color: Color(0xffCCCCCC))
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //display list results
          (placesPredictedList.length > 0)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: placesPredictedList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index)
                      {
                        return PlacePredictionTileDesign(
                          predictedPlaces: placesPredictedList[index],
                        );
                      },
                    separatorBuilder: (BuildContext context, int index)
                    {
                      return Divider(
                        height: Adaptive.h(0.2),
                        color: Colors.grey,
                        thickness: 1,
                      );
                    },
                  ),
          )
                  : Container(),
        ],
      ),
    );
  }
}
