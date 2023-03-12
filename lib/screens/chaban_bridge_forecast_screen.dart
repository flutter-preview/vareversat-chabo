import 'package:chabo/bloc/chaban_bridge_forecast/chaban_bridge_forecast_bloc.dart';
import 'package:chabo/bloc/closing_notification/closing_notification_bloc.dart';
import 'package:chabo/bloc/duration_picker/duration_picker_bloc.dart';
import 'package:chabo/bloc/notification_service_cubit.dart';
import 'package:chabo/bloc/opening_notification/opening_notification_bloc.dart';
import 'package:chabo/bloc/time_picker/time_picker_bloc.dart';
import 'package:chabo/custom_widgets_state.dart';
import 'package:chabo/models/chaban_bridge_status.dart';
import 'package:chabo/screens/error_screen.dart';
import 'package:chabo/screens/settings_screen.dart';
import 'package:chabo/widgets/chaban_bridge_forecast_list.dart';
import 'package:chabo/widgets/chaban_bridge_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChabanBridgeForecastScreen extends StatefulWidget {
  const ChabanBridgeForecastScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChabanBridgeForecastScreenState();
  }
}

class _ChabanBridgeForecastScreenState
    extends CustomWidgetState<ChabanBridgeForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
        heroTag: 'settingsButtonIcon',
        child: const Icon(Icons.settings),
      ),
      body: SafeArea(
        child: BlocBuilder<ChabanBridgeForecastBloc, ChabanBridgeForecastState>(
          builder: (context, state) {
            switch (state.status) {
              case ChabanBridgeForecastStatus.failure:
                return ErrorScreen(errorMessage: state.message);
              case ChabanBridgeForecastStatus.success:
                if (state.chabanBridgeForecasts.isEmpty) {
                  return const ErrorScreen(errorMessage: 'Empty return');
                }
                var bridgeStatus = ChabanBridgeStatus(
                    currentChabanBridgeForecast:
                        state.currentChabanBridgeForecast!,
                    context: context);

                return MultiBlocListener(
                  listeners: [
                    BlocListener<DurationPickerBloc, DurationPickerState>(
                      listener: (context, state) {
                        context
                            .read<NotificationServiceCubit>()
                            .state
                            .computeDurationScheduledNotifications(
                                BlocProvider.of<ChabanBridgeForecastBloc>(
                                        context)
                                    .state
                                    .chabanBridgeForecasts,
                                state,
                                context);
                      },
                    ),
                    BlocListener<TimePickerBloc, TimePickerState>(
                      listener: (context, state) {
                        context
                            .read<NotificationServiceCubit>()
                            .state
                            .computeTimeScheduledNotifications(
                                BlocProvider.of<ChabanBridgeForecastBloc>(
                                        context)
                                    .state
                                    .chabanBridgeForecasts,
                                state,
                                context);
                      },
                    ),
                    BlocListener<OpeningNotificationBloc,
                        OpeningNotificationState>(
                      listener: (context, state) {
                        context
                            .read<NotificationServiceCubit>()
                            .state
                            .computeOpeningScheduledNotifications(
                                BlocProvider.of<ChabanBridgeForecastBloc>(
                                        context)
                                    .state
                                    .chabanBridgeForecasts,
                                state,
                                context);
                      },
                    ),
                    BlocListener<ClosingNotificationBloc,
                        ClosingNotificationState>(
                      listener: (context, state) {
                        context
                            .read<NotificationServiceCubit>()
                            .state
                            .computeClosingScheduledNotifications(
                                BlocProvider.of<ChabanBridgeForecastBloc>(
                                        context)
                                    .state
                                    .chabanBridgeForecasts,
                                state,
                                context);
                      },
                    )
                  ],
                  child: Column(
                    children: [
                      ChabanBridgeStatusWidget(
                        bridgeStatus: bridgeStatus,
                      ),
                      Expanded(
                        flex: 11,
                        child: ChabanBridgeForecastList(
                          currentChabanBridgeForecast:
                              state.currentChabanBridgeForecast,
                          chabanBridgeForecasts: state.chabanBridgeForecasts,
                          hasReachedMax: state.hasReachedMax,
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
