import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seta/models/user.dart' as model;
import 'package:seta/providers/user_provider.dart';
import 'package:seta/resources/auth_methods.dart';
import 'package:seta/resources/firestore_methods.dart';
import 'package:seta/screens/comments_screen.dart';
import 'package:seta/utils/colors.dart';
import 'package:seta/utils/utils.dart';
import 'package:seta/widgets/delete_report.dart';
import 'package:seta/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final String uid;
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
    required this.uid,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var userData = {};
  bool isFollowing = false;
  bool isLikeAnimating = false;
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //HEADER
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shrinkWrap: true,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? DeleteButton(
                                    text: 'Delete',
                                    backgroundColor: mobileBackgroundColor,
                                    textColor: primaryColor,
                                    borderColor: Colors.grey,
                                    function: () async {
                                      widget.snap['postId'].toString();
                                    },
                                  )
                                : isFollowing
                                    ? DeleteButton(
                                        text: 'Unfollow',
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = false;
                                          });
                                        },
                                      )
                                    : DeleteButton(
                                        text: 'Follow',
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        borderColor: Colors.blue,
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );
                                        },
                                      ),
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    FirestoreMethods()
                                        .deletePost(widget.snap['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text('Delete'),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  //IMAGE
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 100,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          //like comment etc.. section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite_sharp,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_sharp,
                        ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          snap: widget.snap,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.comment_outlined,
                    ),
                  ),
                ),
              ),
            ],
          ),
//description, comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['description']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        snap: widget.snap,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
