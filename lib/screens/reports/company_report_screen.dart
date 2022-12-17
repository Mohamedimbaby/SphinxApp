
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saleing/colors.dart';
import 'package:saleing/model/VistsData.dart';
import 'package:saleing/screens/reports/report_bloc/report_bloc.dart';
import 'package:saleing/styles.dart';
import 'package:saleing/widgets/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompanyReportsScreen extends StatefulWidget {
  const CompanyReportsScreen({Key? key}) : super(key: key);

  @override
  State<CompanyReportsScreen> createState() => _CompanyReportsScreenState();
}

class _CompanyReportsScreenState extends State<CompanyReportsScreen> {
  ReportBloc reportBloc = ReportBloc();
  List<Color> colors = [Colors.green , Colors.grey];
  late LoadingDialog loadingDialog;
  @override
  void initState() {
    loadingDialog = LoadingDialog(context);
    loadingDialog.initialize();
    loadingDialog.style("Loading");
    reportBloc.getCompanyReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc , ReportState>(
      bloc: reportBloc,
      builder: (context, snapshot) {
          return MyReportsWidget(snapshot.visits, snapshot.orders);
      }
    );
  }

}





class MyReportsWidget extends StatelessWidget {
 final List<VisitsData> visits ;
 final List<OrderData> orders;

   const MyReportsWidget(this.visits, this.orders, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondColor,
          title:  Text('Company Reports', style: boldTextStyle.copyWith(color: Colors.white),),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            //Initialize the chart widget
            const SizedBox(height: 20,),
            Text(" Order Reports" , style: boldTextStyle,),
            SfCircularChart(
                legend: Legend(isVisible: true,iconHeight: 30,opacity: 1.0),
                tooltipBehavior: TooltipBehavior(enable: true,),
                series:  <RadialBarSeries<OrderData, String>>[
                  RadialBarSeries<OrderData, String>(
                    useSeriesColor: true,
                    maximumValue: 50,
                    trackOpacity: 0.2,
                    trackBorderWidth: 0,
                    cornerStyle: CornerStyle.bothCurve,
                    dataSource: orders,
                    gap:"1%",
                    dataLabelSettings: const DataLabelSettings(isVisible: false,showZeroValue: false),
                    pointColorMapper: (OrderData data, _) => data.color,
                    xValueMapper: (OrderData sales, _) => sales.month,
                    yValueMapper: (OrderData sales, _) => sales.visits,
                  )
                ]
            ),
            const SizedBox(height: 10,),
            Text(" Visits Reports" , style: boldTextStyle,),
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<VisitsData, String>>[
                  SplineSeries<VisitsData, String>(
                      dataSource: visits,
                      xValueMapper: (VisitsData sales, _) => sales.month,
                      yValueMapper: (VisitsData sales, _) => sales.visits,
                      name: 'Visits',

                      color: mainColor,
                      dataLabelSettings: const DataLabelSettings(isVisible: false)
                  )
                ]),
             const SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   width: 20,
                   height: 20,
                   decoration:  BoxDecoration(
                     shape: BoxShape.circle,
                     border: Border.all(),
                     image: const DecorationImage(
                       image: AssetImage("assets/logo.jpg"),
                       fit: BoxFit.fill
                     )
                   ),
                 ),
                 Text(" @Reports For Sphinx Company" , style: boldTextStyle,),
               ],
             )

          ]),
        ));
  }
}

