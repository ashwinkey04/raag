import 'package:flutter/material.dart';
import 'package:raag/model/music_model.dart';
import 'package:raag/provider/db_provider.dart';
import 'package:raag/provider/song_widget.dart';
import 'package:raag/widgets/loading_indicator.dart';

class MyMusicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBProvider.db.getAllSongs(),
      builder: (context, snapshot) {
        Widget sliver;
        List<Song> songInfo = snapshot.data;
        if (songInfo != null && songInfo.isNotEmpty) {
          sliver = SongWidget(songList: songInfo);
        } else {
          sliver = SliverToBoxAdapter(child: LoadingIndicator());
        }
        return Expanded(child: sliver);
      },
    );
  }
}
