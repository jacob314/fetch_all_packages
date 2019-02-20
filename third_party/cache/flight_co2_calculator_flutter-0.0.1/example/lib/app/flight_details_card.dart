import 'package:flight_co2_calculator_flutter/airport.dart';
import 'package:flight_co2_calculator_flutter/airport_lookup.dart';
import 'package:flight_co2_calculator_flutter_example/app/airport_search_delegate.dart';
import 'package:flight_co2_calculator_flutter_example/app/airport_widget.dart';
import 'package:flight_co2_calculator_flutter_example/app/constants/text_styles.dart';
import 'package:flight_co2_calculator_flutter_example/app/segmented_control.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/bloc_provider.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/flight_details_bloc.dart';
import 'package:flight_co2_calculator_flutter/flight_class.dart';
import 'package:flutter/material.dart';

class FlightDetailsCard extends StatelessWidget {
  FlightDetailsCard({@required this.flightDetails, @required this.airportLookup});
  final FlightDetails flightDetails;
  final AirportLookup airportLookup;

  final Map<FlightClass, Widget> flightClassChildren =
      const <FlightClass, Widget>{
    FlightClass.economy: Text('Economy'),
    FlightClass.business: Text('Business'),
    FlightClass.first: Text('First'),
  };

  final Map<FlightType, Widget> flightTypeChildren = const <FlightType, Widget>{
    FlightType.oneWay: Text('One Way'),
    FlightType.twoWays: Text('Return'),
  };

  void _selectDeparture(BuildContext context) async {
    final departure = await showSearch<Airport>(
        context: context,
        delegate: AirportSearchDelegate(
          airportLookup: airportLookup,
        ));
    final flightDetailsBloc = BlocProvider.of<FlightDetailsBloc>(context);
    flightDetailsBloc.updateDeparture(departure);
  }

  void _selectArrival(BuildContext context) async {
    final arrival = await showSearch<Airport>(
        context: context,
        delegate: AirportSearchDelegate(
          airportLookup: airportLookup,
        ));
    final flightDetailsBloc = BlocProvider.of<FlightDetailsBloc>(context);
    flightDetailsBloc.updateArrival(arrival);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FlightDetailsBloc>(context);
    return Card(
      elevation: 4.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x40068FFA),
              Color(0x4049BFC4),
              Color(0x4089ED91),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16.0),
            AirportWidget(
              iconData: Icons.flight_takeoff,
              title: Text('Departing From', style: TextStyles.caption),
              airport: flightDetails.departure,
              onPressed: () => _selectDeparture(context),
            ),
            SizedBox(height: 16.0),
            AirportWidget(
              iconData: Icons.flight_land,
              title: Text('Flying to', style: TextStyles.caption),
              airport: flightDetails.arrival,
              onPressed: () => _selectArrival(context),
            ),
            SizedBox(height: 16.0),
            SegmentedControl<FlightType>(
              header: Text('Type', style: TextStyles.caption),
              value: flightDetails.flightType,
              children: flightTypeChildren,
              onValueChanged: (flightType) => bloc.updateFlightType(flightType),
            ),
            SizedBox(height: 16.0),
            SegmentedControl<FlightClass>(
              header: Text('Class', style: TextStyles.caption),
              value: flightDetails.flightClass,
              children: flightClassChildren,
              onValueChanged: (flightClass) => bloc.updateFlightClass(flightClass),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
