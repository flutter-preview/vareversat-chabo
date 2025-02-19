import 'package:chabo/bloc/time_slots/time_slots_bloc.dart';
import 'package:chabo/custom_properties.dart';
import 'package:chabo/models/time_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeSlotDialog extends StatelessWidget {
  final int index;

  const TimeSlotDialog({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          CustomProperties.borderRadius,
        ),
      ),
      content: BlocBuilder<TimeSlotsBloc, TimeSlotsState>(
        builder: (context, state) {
          return Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            runSpacing: 10,
            children: [
              Text(
                ' ${AppLocalizations.of(context)!.favoriteSlotsFrom} ',
                style: textTheme.titleMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  showTimePicker(
                    initialEntryMode: TimePickerEntryMode.dialOnly,
                    context: context,
                    initialTime: state.timeSlots[index].from,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context),
                        child: child!,
                      );
                    },
                  ).then((value) => {
                        if (value != null)
                          {
                            BlocProvider.of<TimeSlotsBloc>(context).add(
                              TimeSlotChanged(
                                timeSlot: TimeSlot(
                                  name: state.timeSlots[index].name,
                                  from: value,
                                  to: state.timeSlots[index].to,
                                ),
                                index: index,
                              ),
                            ),
                          },
                      });
                },
                child: Text(
                  state.timeSlots[index].from.format(context),
                  style: textTheme.titleMedium,
                ),
              ),
              Text(
                ' ${AppLocalizations.of(context)!.favoriteSlotsTo} ',
                style: textTheme.titleMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  showTimePicker(
                    initialEntryMode: TimePickerEntryMode.dialOnly,
                    context: context,
                    initialTime: state.timeSlots[index].to,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context),
                        child: child!,
                      );
                    },
                  ).then((value) => {
                        if (value != null)
                          {
                            BlocProvider.of<TimeSlotsBloc>(context).add(
                              TimeSlotChanged(
                                timeSlot: TimeSlot(
                                  name: state.timeSlots[index].name,
                                  from: state.timeSlots[index].from,
                                  to: value,
                                ),
                                index: index,
                              ),
                            ),
                          },
                      });
                },
                child: Text(
                  state.timeSlots[index].to.format(context),
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.check_circle),
            label: Text(
              MaterialLocalizations.of(context).okButtonLabel,
            ),
          ),
        ),
      ],
    );
  }
}
