import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:raag/model/music_model.dart';
import 'package:raag/provider/db_provider.dart';
import 'package:raag/provider/settings_provider.dart';
import 'package:raag/provider/song_widget.dart';
import 'package:raag/view/download_music.dart';
import 'package:raag/view/playback_controls.dart';
import 'package:raag/view/settings.dart';
import 'package:raag/widgets/loading_indicator.dart';

class HomeScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);
    final sliverAppBar = SliverAppBar(
        backgroundColor: Colors.transparent,
        floating: true,
        pinned: false,
        brightness:
            themeProvider.darkTheme ? Brightness.light : Brightness.dark,
        leading: IconButton(
            icon: Icon(
              Icons.download_rounded,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadMusic(url: ''),
                ))),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  )))
        ],
        title: Center(
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            'assets/images/musical.png',
            width: 40,
            height: 40,
          ),
        )));

    return Scaffold(
      body: Stack(children: [
        FutureBuilder(
          future: DBProvider.db.getAllSongs(),
          builder: (context, snapshot) {
            Widget sliver;
            List<Song> songInfo = snapshot.data;
            if (songInfo != null && songInfo.isNotEmpty) {
              sliver = SongWidget(songList: songInfo);
            } else {
              sliver = SliverToBoxAdapter(child: LoadingIndicator());
            }
            return CustomScrollView(
              slivers: [
                sliverAppBar,
                SliverFillRemaining(
                  child: sliver,
                )
              ],
            );
          },
        ),
        PlayBackControls(),
      ]),
    );
  }
}
