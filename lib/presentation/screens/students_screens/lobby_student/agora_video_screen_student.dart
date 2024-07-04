import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/presentation/providers/agora_provider/agora_providers.dart';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:moss_yoga/presentation/screens/students_screens/lobby_student/basic_video_configuration_widget.dart';

// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;

class AgoraVideoScreenStudent extends StatefulWidget {
  final String channelName;
  final String userName;
  final int uid;

  AgoraVideoScreenStudent({
    Key? key,
    required this.channelName,
    required this.userName,
    required this.uid,
  }) : super(key: key);

  // AgoraClient client;

  @override
  State<AgoraVideoScreenStudent> createState() =>
      _AgoraVideoScreenStudentState();
}

class _AgoraVideoScreenStudentState extends State<AgoraVideoScreenStudent> {
  bool switchCamera = true;
  bool switchRender = true;
  List<int> _users = [];

  double xPosition = 0;
  double yPosition = 0;

  List _remoteUid = []; // uid of the remote user

  ///Actual Video Call.
  late RtcEngine _engine;

  ///Logging into Agora RTM itself.
  AgoraRtmClient? _client;

  ///Joining that Channel
  AgoraRtmChannel? _channel;

  bool isJoined = false;

  bool loading = false;

  bool muted = false;

  // late TextEditingController _controller;
  // bool _isUseFlutterTexture = false;
  // bool _isUseAndroidSurfaceView = false;
  // ChannelProfileType _channelProfileType =
  //     ChannelProfileType.channelProfileCommunication;

  // AgoraClient client = AgoraClient(
  //     agoraConnectionData:
  //         AgoraConnectionData(appId: AgoraUtils.appId, channelName: 'test'),
  //     enabledPermission: [Permission.camera, Permission.microphone]);

  @override
  void initState() {
    print('This is the channel name inside screen: ${widget.channelName}');
    print('This is the user id  inside screen: ${widget.uid}');
    super.initState();
    // _controller = TextEditingController(text: widget.channelName);
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    _engine.destroy();
  }

  Future<void> _initEngine() async {
    setState(() {
      loading = true;
    });
    // _engine = createAgoraRtcEngine();
    _engine =
        await RtcEngine.createWithContext(RtcEngineContext(AgoraUtils.appId));
    // _client = await AgoraRtmClient.createInstance(AgoraUtils.appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);

    _engine.setEventHandler(RtcEngineEventHandler(
      error: (err) {
        showMessage('onError err $err, msg ${err.name}');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        showMessage("Local user uid:${uid} joined the channel");
        setState(() {
          _users.add(uid);
          isJoined = true;
        });
      },
      leaveChannel: (RtcStats stats) {
        showMessage(
            '[onLeaveChannel] connection: ${stats.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          _users.clear();
        });
      },
      userJoined: (int rUid, int elapsed) {
        showMessage("Remote user uid:$rUid joined the channel");
        setState(() {
          // _users.add(rUid);
          _remoteUid.add(rUid);
        });
      },
      userOffline: (int remoteUid, UserOfflineReason reason) {
        showMessage("Remote user uid:$remoteUid left the channel");
        setState(() {
          _remoteUid.remove(remoteUid);
        });
      },
    ));

    Future.delayed(Duration(milliseconds: 10));
    await _engine.joinChannel(null, widget.channelName, null, widget.uid);

    ///Callbacks for RTM Client
    // _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
    //   // print('Connection state changed '+'${.toString()}' );
    //   print('Private Message From ' + '${peerId} +${message.text}');
    // };
    // _client?.onConnectionStateChanged = (int state, int reason) {
    //   print('Connection state changed ' +
    //       '${state.toString()},'
    //           'reason ${reason.toString()}');
    //   if (state == 5) {
    //     _channel?.leave();
    //     _client?.logout();
    //     _client?.destroy();
    //     print('logged out');
    //   }
    // };

    ///Join the RTM and RTC channels
    // await _client?.login(null, widget.uid.toString());
    // _channel = await _client?.createChannel(widget.channelName);
    // await _channel?.join();
    // await _engine.joinChannel(
    //   // token: null,
    //   channelId: widget.channelName,
    //   uid: widget.uid, token: '', options: ChannelMediaOptions(),
    // );

    /// Callbacks for RTM
    // _channel?.onMemberJoined = (AgoraRtmMember member) {
    //   print("Member joined: '${member.userId}' channel +${member.channelId} ");
    // };
    // _channel?.onMemberLeft = (AgoraRtmMember member) {
    //   print("Member Left: '${member.userId}' channel +${member.channelId} ");
    // };
    // _channel?.onMessageReceived =
    //     (AgoraRtmMessage message, AgoraRtmMember member) {
    //   print(
    //       "Public Message from: '${member.userId}' channel +${member.channelId} ");
    // };
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void join() async {
    await _engine.startPreview();

    // Set channel options including the client role and channel profile
    // ChannelMediaOptions options = const ChannelMediaOptions(
    //   clientRoleType: ClientRoleType.clientRoleBroadcaster,
    //   channelProfile: ChannelProfileType.channelProfileCommunication,
    // );

    // await _engine.joinChannel(
    //   widget.userName,
    //    widget.channelName,
    //    null,
    //   widget.uid,
    // );
  }

  void leave() {
    setState(() {
      isJoined = false;
      _remoteUid.clear();
    });
    _engine.leaveChannel();
  }

// Build UI
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          body: Stack(children: [
        Center(
          child: renderRemoteView(context),
        ),
        Positioned(
          top: yPosition,
          left: xPosition,
          child: GestureDetector(
            onPanUpdate: (tapInfo) {
              setState(() {
                xPosition += tapInfo.delta.dx;
                yPosition += tapInfo.delta.dy;
              });
            },
            child: Container(
              width: 100,
              height: 130,
              child: const RtcLocalView.SurfaceView(),
            ),
          ),
        ),
        _toolbar(),
      ])),
    );
  }

  Widget renderRemoteView(BuildContext context) {
    if (_remoteUid.isNotEmpty) {
      if (_remoteUid.length == 1) {
        return RtcRemoteView.SurfaceView(
          uid: _remoteUid[0],
          channelId: widget.channelName,
        );
      } else if (_remoteUid.length == 2) {
        return Column(
          children: [
            RtcRemoteView.SurfaceView(
              uid: _remoteUid[0],
              channelId: widget.channelName,
            ),
            RtcRemoteView.SurfaceView(
              uid: _remoteUid[1],
              channelId: widget.channelName,
            ),
          ],
        );
      } else {
        return SizedBox(
          width: CommonFunctions.deviceWidth(context) * 1,
          height: CommonFunctions.deviceHeight(context) * 1,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 11 / 20,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10),
              itemCount: _remoteUid.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: RtcRemoteView.SurfaceView(
                    uid: _remoteUid[index],
                    channelId: widget.channelName,
                  ),
                );
              }),
        );
      }
    } else {
      return Text('Waiting for other user to join');
    }
  }

  Widget _toolbar() {
    return Center(
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 48),
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              onPressed: () {
                _onToggleMute();
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(5),
              fillColor: muted ? Colors.green : Colors.white,
              child: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: muted ? Colors.white : Colors.green,
                size: 40,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                _onCallEnd();
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(15),
              fillColor: Colors.redAccent,
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 45,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                _switchCamera();
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(12),
              fillColor: AppColors.white,
              child: const Icon(
                Icons.switch_camera,
                color: Colors.green,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onCallEnd() {
    _engine.leaveChannel().then((value) {
      context.pop();
    });
  }

  void _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }
}
