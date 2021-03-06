import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_doan/model/country/city.dart';
import 'package:flutter_doan/model/country/country.dart';
import 'package:flutter_doan/model/country/state.dart';


class CountryStateCity extends StatefulWidget {
  TextEditingController country;
  TextEditingController state;
  TextEditingController city;
  Size size;
  InputBorder? textFieldInputBorder;

  CountryStateCity({
    required this.country,
    required this.state,
    required this.city,
    required this.textFieldInputBorder,
    required this.size,

  });

  @override
  _CountryStateCityPickerState createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCity> {
  List<CountryModel> _countryList=[];
  List<StateModel> _stateList=[];
  List<CityModel> _cityList=[];

  List<CountryModel> _countrySubList=[];
  List<StateModel> _stateSubList=[];
  List<CityModel> _citySubList=[];
  String _title='';

  @override
  void initState() {
    super.initState();
    _getCountry();
  }

  Future<void> _getCountry()async{
    _countryList.clear();
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList = body.map((dynamic item) => CountryModel.fromJson(item)).toList();
      _countrySubList=_countryList;
    });
  }

  Future<void> _getState(String countryId)async{
    _stateList.clear();
    _cityList.clear();
    List<StateModel> _subStateList=[];
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/state.json');
    List<dynamic> body = json.decode(jsonString);

    _subStateList = body.map((dynamic item) => StateModel.fromJson(item)).toList();
    _subStateList.forEach((element) {
      if(element.countryId==countryId){
        setState(() {
          _stateList.add(element);
        });
      }
    });
    _stateSubList=_stateList;
  }

  Future<void> _getCity(String stateId)async{
    _cityList.clear();
    List<CityModel> _subCityList=[];
    var jsonString = await rootBundle.loadString('packages/country_state_city_pro/assets/city.json');
    List<dynamic> body = json.decode(jsonString);

    _subCityList = body.map((dynamic item) => CityModel.fromJson(item)).toList();
    _subCityList.forEach((element) {
      if(element.stateId==stateId){
        setState(() {
          _cityList.add(element);
        });
      }
    });
    _citySubList = _cityList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Country TextField
        TextField(
          controller: widget.country,
          onTap: (){
            setState(()=>_title='Country');
            _showDialog(context,widget.size);
          },
          decoration: InputDecoration(
              isDense: true,
              hintStyle: TextStyle(
                  color: Colors.black87
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              hintText: 'Select Country',
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black87,),
              border: widget.textFieldInputBorder?? OutlineInputBorder()
          ),
          readOnly: true,
        ),
        SizedBox(height: 8.0),

        ///State TextField
        TextField(

          controller: widget.state,
          onTap: (){
            setState(()=>_title='State');
            if(widget.country.text.isNotEmpty)
              _showDialog(context,widget.size);
            else _showSnackBar('Select Country');
          },
          decoration: InputDecoration(
              isDense: true,
              hintStyle: TextStyle(
                  color: Colors.black87
              ),
              hintText: 'Select State',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black87,),
              border: widget.textFieldInputBorder?? OutlineInputBorder()
          ),
          readOnly: true,
        ),
        SizedBox(height: 8.0),

        ///City TextField
        TextField(
          controller: widget.city,
          onTap: (){
            setState(()=>_title='City');
            if(widget.state.text.isNotEmpty)
              _showDialog(context,widget.size);
            else _showSnackBar('Select State');
          },
          decoration: InputDecoration(
              isDense: true,
              hintText: 'Select City',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: Colors.black38,
                ),
              ),
              hintStyle: TextStyle(
                  color: Colors.black87
              ),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black87,),
              border: widget.textFieldInputBorder?? OutlineInputBorder()
          ),
          readOnly: true,
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, Size size){
    TextEditingController _controller=TextEditingController();
    TextEditingController _controller2=TextEditingController();
    TextEditingController _controller3=TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context,__,___){
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Align(
                alignment: Alignment.center,
                child:  Container(
                  height: size.height/2,
                  width: size.width/2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(_title,style: TextStyle(color:Colors.grey.shade800,
                          fontSize: 17,fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
                      ///Text Field
                      TextField(

                        controller: _title=='Country'
                            ? _controller
                            : _title=='State'
                            ? _controller2
                            : _controller3,
                        onChanged: (val){
                          setState(() {
                            if(_title=='Country'){
                              _countrySubList = _countryList.where((element) =>
                                  element.name.toLowerCase().contains(_controller.text.toLowerCase())).toList();
                            }
                            else if(_title=='State'){
                              _stateSubList = _stateList.where((element) =>
                                  element.name.toLowerCase().contains(_controller2.text.toLowerCase())).toList();
                            }
                            else if(_title=='City'){
                              _citySubList = _cityList.where((element) =>
                                  element.name.toLowerCase().contains(_controller3.text.toLowerCase())).toList();
                            }
                          });
                        },
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16.0
                        ),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Search here...",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                            prefixIcon: Icon(Icons.search, color: Colors.grey,)
                        ),
                      ),
                      ///Dropdown Items
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _title=='Country'
                                ? _countrySubList.length
                                : _title=='State'
                                ? _stateSubList.length
                                : _citySubList.length,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context,index){
                              return InkWell(
                                onTap: ()async{
                                  setState((){
                                    if(_title=="Country"){
                                      widget.country.text= _countrySubList[index].name;
                                      _getState(_countrySubList[index].id);
                                      _countrySubList=_countryList;
                                      widget.state.clear();
                                      widget.city.clear();
                                    }
                                    else if(_title=='State'){
                                      widget.state.text= _stateSubList[index].name;
                                      _getCity(_stateSubList[index].id);
                                      _stateSubList = _stateList;
                                      widget.city.clear();
                                    }
                                    else if(_title=='City'){
                                      widget.city.text= _citySubList[index].name;
                                      _citySubList = _cityList;
                                    }
                                  });
                                  _controller.clear();
                                  _controller2.clear();
                                  _controller3.clear();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20.0,left: 10.0,right: 10.0),
                                  child: Text(
                                      _title=='Country'
                                          ? _countrySubList[index].name
                                          : _title=='State'
                                          ? _stateSubList[index].name
                                          :_citySubList[index].name,
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 16.0
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          if(_title=='City' && _citySubList.isEmpty){
                            widget.city.text= _controller3.text;
                          }
                          _countrySubList=_countryList;
                          _stateSubList = _stateList;
                          _citySubList = _cityList;

                          _controller.clear();
                          _controller2.clear();
                          _controller3.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_,anim,__,child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 16.0)))
    );
  }
}
