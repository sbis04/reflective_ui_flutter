import 'package:flutter/material.dart';

import 'model/user.dart';
import 'sample_data/user_samples.dart';

class PageContent extends StatefulWidget {
  const PageContent({super.key, required this.onThemeToggle});

  final Function onThemeToggle;

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Contacts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 36.0,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              widget.onThemeToggle();
                              setState(() {});
                            },
                            child: Icon(
                              Theme.of(context).brightness == Brightness.light
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        primary: false,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 24),
                        shrinkWrap: true,
                        itemCount: userDetails.length,
                        itemBuilder: (context, index) {
                          return UserListTile(
                            user: userDetails[index],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Opacity(
                    opacity: 0.4,
                    child: Icon(
                      Icons.house_rounded,
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ),
                  Opacity(
                    opacity: 0.4,
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                  Opacity(
                    opacity: 1,
                    child: Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            Text(
              user.username,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_circle_right_outlined,
          color: Colors.white,
          size: 30,
        ),
      ],
    );
  }
}
