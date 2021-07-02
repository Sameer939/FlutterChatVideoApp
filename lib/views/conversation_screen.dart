import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  // const ConversationScreen({ Key? key }) : super(key: key);
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;
  // var textTo = widget.chatRoomId.toString().
  // var MessagingTo = getChatRoomId(a, b)

  Widget ChatMessageList(){
    return Container(
      margin: EdgeInsets.only(bottom: 80.0),
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              // print("length hai bhai yeh = ${snapshot.data.docs.length}");
              
              return MessageTile(
                snapshot.data.docs[index]["message"],
                Constants.myName == snapshot.data.docs[index]["sendBy"],
                snapshot.data.docs[index]["time"],
                );
            }
          ) :Container() ;
        }

      ),
    );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){ 
       Map<String, dynamic> messageMap = {
      "message" : messageController.text,
      "sendBy" : Constants.myName,
      "time" : DateTime.now().microsecondsSinceEpoch,
    }; 
    databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
    messageController.text = "";
    }
  }
  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });

    } );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
          Container(
            padding: EdgeInsets.symmetric(horizontal: 85,vertical: 10),
            child: Text(widget.chatRoomId.toString()
            .replaceAll("_", "")
            .replaceAll(Constants.myName, ""),
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_horiz),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: (){

              },
            )
          ],
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
             Container(
               alignment: Alignment.bottomCenter,
               child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      ),
             
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:[
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/send.png",)),
                    ),
                  ],
                ),
              ),
             ),
          ],
        ),
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  int sentTime;
  MessageTile(this.message,this.isSendByMe,this.sentTime);

  timeData(int time){
    return  DateTime
    .fromMicrosecondsSinceEpoch(sentTime)
    .toString()
    .substring(11,16);
  }



  @override
  Widget build(BuildContext context) {

    
    return Container(
      child: Container(
      padding: EdgeInsets.only(
        left: isSendByMe ? 0:  10,
        right: isSendByMe ? 10 : 0),

        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment: isSendByMe ? 
          Alignment.centerRight 
          : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                 colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
              ),
              borderRadius: isSendByMe ?
                BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
                ): BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)
                )
            ),
            child: Column(
              crossAxisAlignment :CrossAxisAlignment.end,
              children: [
                  Text(message,style: TextStyle(
                      color: Colors.white, fontSize: 16
                     ),
                    ),
                SizedBox(height: 6.0,),
                  Text(timeData(sentTime),style: TextStyle(
                      color: Colors.white, fontSize: 11
                    ),
                  ),
                
              ],
            ),
        ),
      ),
    );
  }
}