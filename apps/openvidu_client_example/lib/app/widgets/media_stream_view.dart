import 'package:flutter/material.dart';
import 'package:openvidu_client/openvidu_client.dart';

import 'future_wrapper.dart';
import 'no_video.dart';

class MediaStreamView extends StatefulWidget {
  final bool mirror;
  final Participant participant;
  final BorderRadiusGeometry? borderRadius;
  final String? userName;

  const MediaStreamView({
    super.key,
    required this.participant,
    this.mirror = false,
    this.borderRadius,
    this.userName,
  });

  @override
  State<MediaStreamView> createState() => _MediaStreamViewState();
}

class _MediaStreamViewState extends State<MediaStreamView> {
  late RTCVideoRenderer _render;

  void setOutput() {}

  @override
  void initState() {
    super.initState();
    _render = RTCVideoRenderer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.participant.stream == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: widget.borderRadius,
          border: Border.all(color: Colors.grey),
        ),
      );
    } else {
      return FutureWrapper(
        future: _render.initialize(),
        builder: (context) {
          _render.srcObject = widget.participant.stream;
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: widget.borderRadius,
              border: Border.all(color: Colors.grey),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                (widget.participant.videoActive)
                    ? RTCVideoView(
                        _render,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        mirror: widget.mirror,
                      )
                    : const NoVideoWidget(),
                if (widget.userName != null && widget.userName?.trim() != '')
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, left: 5.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.userName ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                if (widget.participant.metadata != null)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10,
                    ),
                    child: Text(widget.participant.metadata!["clientData"]),
                  ),
              ],
            ),
          );
        },
      );
    }
  }
}
