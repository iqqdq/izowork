import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class ChatListItemWidget extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItemWidget({
    Key? key,
    required this.chat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isGroupChat = chat.chatType == "GROUP";

    DateTime? dateTime = chat.lastMessage == null
        ? null
        : chat.lastMessage!.createdAt.toUtc().toLocal();

    bool isAudio = chat.lastMessage == null
        ? false
        : chat.lastMessage!.files.isEmpty
            ? false
            : chat.lastMessage!.files.first.mimeType == null
                ? false
                : chat.lastMessage!.files.first.mimeType!.contains('audio') ||
                    chat.lastMessage!.files.first.name.contains('m4a');

    bool isFile = chat.lastMessage == null
        ? false
        : !isAudio && chat.lastMessage!.files.isNotEmpty;

    String? url = chat.user?.avatar;

    return Container(
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: HexColors.grey20),
            ),
            color: chat.unreadCount > 0
                ? HexColors.additionalVioletLight
                : HexColors.white),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10.0),
                    child: Row(children: [
                      /// AVATAR
                      AvatarWidget(
                        url: avatarUrl,
                        endpoint: url,
                        size: 40.0,
                        isGroupAvatar: _isGroupChat,
                      ),

                      const SizedBox(width: 10.0),

                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// USER NAME
                              Text(
                                chat.user?.name ?? chat.name ?? '-',
                                maxLines: 1,
                                style: TextStyle(
                                  color: HexColors.grey50,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4.0),

                              /// MESSAGE TEXT
                              Text(
                                isAudio
                                    ? Titles.audioMessage
                                    : isFile
                                        ? Titles.file
                                        : chat.lastMessage?.text ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI',
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ]),
                      ),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// DATE
                            TitleWidget(
                              text: chat.lastMessage == null
                                  ? ''
                                  : dateTime == null
                                      ? ''
                                      : DateTimeFormatter()
                                          .formatDateTimeToString(
                                          dateTime: dateTime,
                                          showTime: true,
                                          showMonthName: true,
                                        ),
                              padding: EdgeInsets.zero,
                              textAlign: TextAlign.end,
                              isSmall: true,
                            ),
                            const SizedBox(height: 4.0),

                            /// MESSAGE COUNT
                            chat.unreadCount > 0
                                ? CountWidget(count: chat.unreadCount)
                                : const SizedBox(height: 20.0)
                          ]),
                    ])),
                onTap: () => onTap())));
  }
}
