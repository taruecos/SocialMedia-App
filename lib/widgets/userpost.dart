import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/custom_card.dart';
import 'package:social_media_app/components/custom_image.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/pages/profile.dart';
import 'package:social_media_app/screens/view_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatelessWidget {
  final PostModel? post;
  final Future<UserModel?> Function(String userId)? fetchUser;
  final String? currentUserId;

  UserPost({this.post, this.fetchUser, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    bool isMe = currentUserId == post!.userId;
    return CustomCard(
      onTap: () {},
      borderRadius: BorderRadius.circular(10.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return ViewImage(post: post);
        },
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onClosed: (v) {},
        closedColor: Theme.of(context).cardColor,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Stack(
            children: [
              Column(
                children: [
                  buildImage(),
                  buildDetails(context),
                ],
              ),
              buildUser(context, isMe),
            ],
          );
        },
      ),
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: CustomImage(
        imageUrl: post?.itemImage ?? '',
        height: 350.0,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget buildDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.0),
          if (post!.description != null && post!.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 3.0),
              child: Text(
                '${post?.description ?? ""}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption!.color,
                  fontSize: 15.0,
                ),
                maxLines: 2,
              ),
            ),
          SizedBox(height: 3.0),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              timeago.format(post!.timestamp!.toDate()),
              style: TextStyle(fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUser(BuildContext context, bool isMe) {
    return FutureBuilder<UserModel?>(
      future: fetchUser!(post!.userId!),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          UserModel user = snapshot.data!;
          return Visibility(
            visible: !isMe,
            child: buildUserHeader(context, user),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildUserHeader(BuildContext context, UserModel user) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: GestureDetector(
          onTap: () => showProfile(context, profileId: user.id!),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: buildUserRow(context, user),
          ),
        ),
      ),
    );
  }

  Widget buildUserRow(BuildContext context, UserModel user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (user.photoUrl == null || user.photoUrl!.isEmpty)
            ? CircleAvatar(
                radius: 20.0,
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                child: Center(
                  child: Text(
                    '${user.username![0].toUpperCase()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            : CircleAvatar(
                radius: 20.0,
                backgroundImage: CachedNetworkImageProvider('${user.photoUrl}'),
              ),
        SizedBox(width: 5.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.username ?? ""}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }

  showProfile(BuildContext context, {String? profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => Profile(profileId: profileId),
      ),
    );
  }
}
