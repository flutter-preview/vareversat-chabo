import 'package:chabo/bloc/chaban_bridge_forecast/chaban_bridge_forecast_bloc.dart';
import 'package:chabo/bloc/scroll_status/scroll_status_bloc.dart';
import 'package:chabo/models/abstract_chaban_bridge_forecast.dart';
import 'package:chabo/widgets/ad_banner_widget.dart';
import 'package:chabo/widgets/forecast/forecast_list_item_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ForecastListWidget extends StatefulWidget {
  const ForecastListWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForecastListWidgetState();
  }
}

class _ForecastListWidgetState extends State<ForecastListWidget> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          BlocProvider.of<ScrollStatusBloc>(context).add(
            ScrollStatusChanged(),
          );
        }
        return true;
      },
      child: BlocBuilder<ChabanBridgeForecastBloc, ChabanBridgeForecastState>(
        builder: (context, state) {
          return ListView.separated(
            cacheExtent: 5000,
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              return ForecastListItemWidget(
                  key: GlobalObjectKey(
                      state.chabanBridgeForecasts[index].hashCode),
                  isCurrent: state.chabanBridgeForecasts[index] ==
                      state.currentChabanBridgeForecast,
                  hasPassed: state
                      .chabanBridgeForecasts[index].circulationReOpeningDate
                      .isBefore(DateTime.now()),
                  chabanBridgeForecast: state.chabanBridgeForecasts[index],
                  index: index);
            },
            itemCount: state.chabanBridgeForecasts.length,
            controller:
                BlocProvider.of<ScrollStatusBloc>(context).scrollController,
            separatorBuilder: (BuildContext context, int index) {
              if ((index + 1 <= state.chabanBridgeForecasts.length &&
                  state.chabanBridgeForecasts[index].circulationClosingDate
                          .month !=
                      state.chabanBridgeForecasts[index + 1]
                          .circulationClosingDate.month)) {
                return _MonthWidget(
                  chabanBridgeForecast: state.chabanBridgeForecasts[index + 1],
                );
              }
              if (((index % 10 == 0 ||
                          index ==
                              state.chabanBridgeForecasts.indexOf(
                                  state.currentChabanBridgeForecast!)) &&
                      index != 0) &&
                  !kIsWeb) {
                return const AdBannerWidget();
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

class _MonthWidget extends StatelessWidget {
  final AbstractChabanBridgeForecast chabanBridgeForecast;

  const _MonthWidget({Key? key, required this.chabanBridgeForecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: Center(
              child: Text(
                DateFormat.MMMM(Localizations.localeOf(context).languageCode)
                    .format(
                  chabanBridgeForecast.circulationClosingDate,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}