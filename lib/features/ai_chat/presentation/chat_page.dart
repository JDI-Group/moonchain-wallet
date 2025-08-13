import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:moonchain_wallet/common/common.dart';
import 'package:moonchain_wallet/features/common/app_nav_bar/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mxc_ui/mxc_ui.dart';

import 'chat_presenter.dart';
import 'chat_state.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ProviderBase<ChatPresenter> get presenter => chatPagePageContainer.actions;

  @override
  ProviderBase<ChatState> get state => chatPagePageContainer.state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatPresenter = ref.watch(presenter);
    final chatState = ref.watch(state);
    String translate(String key) => FlutterI18n.translate(context, key);
    return MxcPage(
      layout: LayoutType.column,
      useContentPadding: false,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorsTheme.of(context).black,
      presenter: ref.watch(presenter),
      appBar: AppNavBar(title: "${translate('moonchain')} ${translate('ai')}"),
      children: [
        Expanded(
          child: Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 0, left: 24, right: 24),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.height * 0.349,
                              // margin: EdgeInsets.only(top: ),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                                gradient: LinearGradient(
                                  stops: [
                                    0.0, // location 0.00
                                    0.5, // location 0.50
                                    1.0, // location 1.00
                                  ],
                                  colors: [
                                    Color(0XFFD1F258),
                                    Color(0XFFE3E3DE),
                                    Color(0XFF9166FF),
                                  ],
                                  begin: Alignment(0.5,
                                      -1.0), // UnitPoint(x:0.5, y:0) in SwiftUI is top center
                                  end: Alignment(0.5,
                                      1.0), // UnitPoint(x:0.5, y:1) in SwiftUI is bottom center
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorsTheme.of(context).black,
                                    ),
                                    child: SvgPicture.asset(
                                      Assets.svg.aiBlack,
                                      height: 32,
                                      width: 32,
                                      colorFilter: ColorFilter.mode(
                                          ColorsTheme.of(context).primary,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                  Text(
                                      translate(
                                          "${translate('moonchain')} ${translate('ai')}"),
                                      style: FontTheme.of(context)
                                          .h4()
                                          .copyWith(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w800,
                                            color:
                                                ColorsTheme.of(context).black,
                                          )),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                      translate(
                                          "${translate('moonchain')} ${translate('ai')}"),
                                      style: FontTheme.of(context)
                                          .body2()
                                          .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                ColorsTheme.of(context).black,
                                          )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GridView.count(
                              shrinkWrap:
                                  true, // so it doesn't take the whole screen
                              crossAxisCount: 2, // 2 items per row
                              mainAxisSpacing: 10, // vertical spacing
                              crossAxisSpacing: 10, // horizontal spacing
                              childAspectRatio: 138 / 44, // width/height ratio
                              padding: const EdgeInsets.all(0),
                              children: generatePreSetConversations(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: ColorsTheme.of(context).backgroundGrey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MxcTextField(
                              key: const Key('messageTextField'),
                              controller: chatPresenter.messageTextController,
                              focusNode: chatPresenter.messageFocusNode,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              Assets.svg.addImage,
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                  ColorsTheme.of(context).white,
                                  BlendMode.srcIn),
                            ),
                          ),
                          // const SizedBox(
                          //   width: Sizes.space2XSmall,
                          // ),
                          IconButton(
                            onPressed: () {},
                            padding: const EdgeInsets.all(0),
                            icon: Container(
                                padding: const EdgeInsets.all(Sizes.space2XSmall),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsTheme.of(context).primary,
                                ),
                                child: SvgPicture.asset(Assets.svg.send)),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }
}

final presetButtonsProps = [
  {
    "title": "pending_swaps",
    "icon": Assets.svg.aiPending,
  },
  {
    "title": "market_overview",
    "icon": Assets.svg.aiMarketOverview,
  },
  {
    "title": "view_portfolio",
    "icon": Assets.svg.aiPorfolio,
  },
  {
    "title": "airdrop_status",
    "icon": Assets.svg.aiRanking,
  },
];

List<Widget> generatePreSetConversations() => presetButtonsProps
    .map(
      (e) => PreSetConversations(
          onTap: () {}, title: e['title']!, icon: e['icon']!),
    )
    .toList();

class PreSetConversations extends StatelessWidget {
  final Function onTap;
  final String title;
  final String icon;
  const PreSetConversations(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    String translate(String key) => FlutterI18n.translate(context, key);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ColorsTheme.of(context).backgroundGrey,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(
            width: 10,
          ),
          Text(translate(title),
              style: FontTheme.of(context)
                  .subtitle2()
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
