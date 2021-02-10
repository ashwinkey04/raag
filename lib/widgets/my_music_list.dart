import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:raag/model/music_model.dart';
import 'package:raag/provider/audio_helper.dart';
import 'package:raag/provider/db_provider.dart';
import 'package:raag/provider/player_provider.dart';
import 'package:raag/view/playback_controls.dart';
import 'package:raag/widgets/loading_indicator.dart';

class MyMusicList extends StatefulWidget {
  @override
  _MyMusicListState createState() => _MyMusicListState();
}

class _MyMusicListState extends State<MyMusicList>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    playFABController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    playFABController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: FutureBuilder(
        future: DBProvider.db.getAllSongs(),
        builder: (context, snapshot) {
          List<SongModel> songInfo = snapshot.data;
          if (songInfo.isNotEmpty) {
            return Stack(
              children: [
                ListView.builder(
                    itemCount: songInfo.length,
                    itemBuilder: (context, songIndex) {
                      final provider = Provider.of<PlayerProvider>(context);
                      SongModel song = songInfo[songIndex];
                      if (song.displayName.contains(".mp3"))
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 0.7),
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 0.7),
                            ),
                          ),
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      size: 20.0,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg: 'Feature yet to be released');
                                      showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                              100,
                                              100,
                                              0,
                                              100), //TODO Should not be constant
                                          items: [
                                            PopupMenuItem<String>(
                                                child: const Text('Like'),
                                                value: ''),
                                            PopupMenuItem<String>(
                                                child: const Text(
                                                    'Add to Playlist'),
                                                value: ''),
                                            PopupMenuItem<String>(
                                                child: const Text('Song info'),
                                                value: ''),
                                          ]);
                                    },
                                  )
                                ],
                              ),
                              title: InkWell(
                                onTap: () {
                                  if (provider.isPlaying)
                                    provider.pause();
                                  else
                                    provider
                                        .play(
                                            "file://${song.filePath}",
                                            song.title,
                                            song.album,
                                            song.artist,
                                            song.albumArtwork,
                                            Duration(
                                                minutes: 1)) //TODO Duration
                                        .then((err) {
                                      print(err);
                                    });
                                  playFABController.forward();
                                },
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: getAlbumArt(song.albumArtwork,
                                          screenWidth, context),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.03,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(song.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                          Text(song.artist,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                          Text(
                                              parseToMinutesSeconds(
                                                  int.parse(song.duration)),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      return SizedBox(
                        height: 0,
                      );
                    }),
                PlayBackControls(),
              ],
            );
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}
