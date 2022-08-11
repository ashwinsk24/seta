import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seta/utils/colors.dart';
import 'package:seta/utils/global_variable.dart';
import 'package:seta/widgets/post_card.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

_invitationlink() async {
  final Uri url = Uri.parse('https://discord.gg/T8GKg3RJTU');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

_updatelink() async {
  final Uri url = Uri.parse(
      'https://drive.google.com/file/d/1LS7iHAfkP-Fs1E1gF6YsBMfW2X8mM_GB/view?usp=sharing');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/seta_logo.svg',
          color: primaryColor,
          height: 50,
        ),
        actions: [
          IconButton(
            onPressed: _invitationlink,
            icon: const Icon(Icons.explore_rounded),
          ),
          IconButton(
            onPressed: _updatelink,
            icon: const Icon(Icons.tips_and_updates),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
