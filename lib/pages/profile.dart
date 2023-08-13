import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_media_app/auth/login/login.dart';
import 'package:social_media_app/components/stream_grid_wrapper.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/edit_profile.dart';
import 'package:social_media_app/screens/list_posts.dart';
import 'package:social_media_app/screens/settings.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/widgets/post_tiles.dart';

import '../utils/constants.dart';

class Profile extends StatefulWidget {
  final profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool isLoading = false;
  int postCount = 0;
  UserModel? users;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();

  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Constants.appName,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          widget.profileId == firebaseAuth.currentUser!.uid
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => Setting(),
                          ),
                        );
                      },
                      child: Icon(
                        Ionicons.settings,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(width: 15),
          widget.profileId == firebaseAuth.currentUser!.uid
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () async {
                        await firebaseAuth.signOut();
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => Login(),
                          ),
                        );
                      },
                      child: Icon(
                        Ionicons.log_out,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            toolbarHeight: 5.0,
            collapsedHeight: 6.0,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: StreamBuilder(
                stream: usersRef.doc(widget.profileId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data?.data() is Map<String, dynamic>) {
                    UserModel user = UserModel.fromJson(
                        snapshot.data!.data() as Map<String, dynamic>);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: user.photoUrl!.isEmpty
                                  ? CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor:
                                          Color.fromARGB(255, 202, 196, 163),
                                      child: Center(
                                        child: Text(
                                          '${user.username![0].toUpperCase()}',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        '${user.photoUrl}',
                                      ),
                                    ),
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 32.0),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: false,
                                      child: SizedBox(width: 10.0),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 150.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                            user.username!,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            maxLines: null,
                                          ),
                                        ),
                                        SizedBox(height: 3.0),
                                        Text(
                                          user.email!,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildProfileButton(user),

                                    //edit profile set
                                    // : buildLikeButton()
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user.bio!.isEmpty
                                  ? Container()
                                  : Container(
                                      width: 200,
                                      child: Text(
                                        user.bio!,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                              Row(
                                children: [
                                  Text(
                                    user.country!,
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 1.0),
                                  Icon(
                                    Ionicons.location,
                                    color:
                                        const Color.fromARGB(255, 255, 59, 59),
                                    size: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index > 0) return null;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            'Garde-robe  ',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Icon(
                            Ionicons.shirt,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 15,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              DocumentSnapshot doc =
                                  await usersRef.doc(widget.profileId).get();
                              var currentUser = UserModel.fromJson(
                                doc.data() as Map<String, dynamic>,
                              );
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => ListPosts(
                                    userId: widget.profileId,
                                    username: currentUser.username,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Ionicons.grid_outline),
                          )
                        ],
                      ),
                    ),
                    buildPostView()
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  buildCount(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
        SizedBox(height: 3.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu-Regular',
          ),
        )
      ],
    );
  }

  buildProfileButton(user) {
    //if isMe then display "edit profile"

    bool isMe = widget.profileId == firebaseAuth.currentUser!.uid;
    if (isMe) {
      return buildEditButton(
          text: "Edit Profile",
          function: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => EditProfile(
                  user: user,
                ),
              ),
            );
          });
    }
  }

  buildEditButton({String? text, Function()? function}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Icon(
          Ionicons.create,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  buildPostView() {
    return buildGridPost();
  }

  buildGridPost() {
    return StreamGridWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: postRef
          .where('ownerId', isEqualTo: widget.profileId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        PostModel posts =
            PostModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return PostTile(
          post: posts,
        );
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: favUsersRef
          .where('postId', isEqualTo: widget.profileId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
          return GestureDetector(
            onTap: () {
              if (docs.isEmpty) {
                favUsersRef.add({
                  'userId': currentUserId(),
                  'postId': widget.profileId,
                  'dateCreated': Timestamp.now(),
                });
              } else {
                favUsersRef.doc(docs[0].id).delete();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0,
                  )
                ],
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  docs.isEmpty
                      ? CupertinoIcons.heart
                      : CupertinoIcons.heart_fill,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
