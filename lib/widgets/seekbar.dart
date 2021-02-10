import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raag/provider/audio_helper.dart';
import 'package:raag/provider/player_provider.dart';

import '../main.dart';

class SeekBar extends StatefulWidget {
  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayerProvider>(context);

    return Row(
      children: <Widget>[
        Text(
          provider.positionText,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Theme.of(context).accentColor,
                  overlayColor: Theme.of(context).dividerColor,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 3,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Theme.of(context).accentColor,
                  inactiveTrackColor: Theme.of(context).dividerColor,
                ),
                child: Slider(
                  value: slider ?? 0,
                  onChanged: (value) {
                    setState(() {
                      slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    if (provider.duration != null) {
                      musicPlayer.seek(provider.duration.inSeconds.toDouble());
                    }
                  },
                )),
          ),
        ),
        Text(
          formatDuration(provider.duration),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
