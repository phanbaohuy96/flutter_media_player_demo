import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:poc_media_player/presentation/theme/theme_button.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final IjkMediaController _controller = IjkMediaController();
  final TextEditingController _textController = TextEditingController(
    text: 'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
  );

  ImageProvider provider;

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _controller
      ..setIjkPlayerOptions(
        [
          TargetPlatform.android,
        ],
        [
          IjkOption(IjkOptionCategory.player, 'mediacodec', 0),
        ],
      )
      ..setNetworkDataSource(_textController.text, autoPlay: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: StreamBuilder<IjkStatus>(
            stream: _controller.ijkStatusStream,
            initialData: _controller.ijkStatus,
            builder: (ctx, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildInputURL(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 16.0 * 9,
                      child: IjkPlayer(mediaController: _controller),
                    ),
                    _buildScreenBtn(snapshot.data != IjkStatus.error),
                    provider == null
                        ? Container()
                        : Image(
                            image: provider,
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputURL() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter video url (.mp4, .m3u8)',
              ),
            ),
          ),
          ThemeButton.primary(
            context: context,
            title: 'Apply',
            onPressed: () {
              _controller
                ..stop()
                ..setNetworkDataSource(
                  _textController.text,
                  autoPlay: true,
                );
            },
          )
        ],
      ),
    );
  }

  Widget _buildScreenBtn(bool visible) {
    if (visible) {
      return ThemeButton.primary(
        context: context,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        onPressed: () async {
          final uint8List = await _controller.screenShot();
          if (uint8List == null) {
            return;
          }
          provider = MemoryImage(uint8List);
          setState(() {});
        },
        title: 'Screen shot',
      );
    } else {
      return const SizedBox();
    }
  }
}
