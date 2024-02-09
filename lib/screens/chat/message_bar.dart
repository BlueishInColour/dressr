import 'package:flutter/material.dart';

class MessageBarr extends StatefulWidget {
  const MessageBarr({super.key});

  @override
  State<MessageBarr> createState() => MessageBarrState();
}

class MessageBarrState extends State<MessageBarr> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [

       Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          // height: 65,
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        showSendOptions = !showSendOptions;
                      });
                    },
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      showSendOptions
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up_sharp,
                      color: Colors.white60,
                    )),
                title: MessageBarr(
                  MessageBarrHitText: widget.hintText,
                  MessageBarrColor: Colors.transparent,
                  onSend: (text) async {
                    Map<String, dynamic> message = {
                      'senderId': FirebaseAuth.instance.currentUser!.uid,
                      'reciever': 'tinuke',
                      'recieverId': widget.uid,
                      'text': text,
                      'picture': '',
                      'voiceNote': '',
                      'timestamp': Timestamp.now(),
                      'status': 'seen',
                      'listOfChatters': chatRoom,
                    };

                    debugPrint('about to send message');

                    await FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(chatKey)
                        .collection('messages')
                        .add(message);
                    // chatRoom.map((e) async =>);
                    // }

                    debugPrint('message sent');
                  },
                  sendButtonColor: Colors.white60,
                  actions: [],
                ),
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.all(0),
                minLeadingWidth: 0,
              ),
            ],
          ),
        ),
        //send message buttons
        showSendOptions
            ? Container(
                color: Colors.black,
                height: 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        tile(context, text: '#50'),
                        tile(context, text: '#100'),
                        tile(context, text: '#200'),
                        tile(context, text: '#500'),
                        tile(context, text: '#1k'),
                      ],
                    )
                  ],
                ),
              )
            : SizedBox.shrink()
    ],),)}
}
