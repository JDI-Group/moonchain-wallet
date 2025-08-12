import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moonchain_wallet/common/assets.gen.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

import '../../../dapps_presenter.dart';
import '../dapps_layout.dart';

Widget buildCard(
  BuildContext context,
  Dapp dapp,
  VoidCallback? onTap,
  bool isEditMode, {
  DAppsPagePresenter? actions,
  void Function()? shatter,
  bool animated = false,
  bool contextMenuAnimation = false,
}) {
  String? image;
  if (dapp is Bookmark) {
    if ((dapp).image != null) {
      image = (dapp).image!;
    } else {
      actions!.updateBookmarkFavIcon(dapp);
    }
  }

  final name = dapp is Bookmark ? (dapp).title : '';
  // final url = (dapp).url;
  // final info = (dapp).description;

  return GestureDetector(
    onTap: () {
      if (animated) {
        Navigator.pop(context);
        Future.delayed(
          const Duration(milliseconds: 500),
          () => onTap!(),
        );
      } else if (onTap != null) {
        onTap();
      }
    },
    child: SizedBox(
      height: 82,
      width: 84,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: ColorsTheme.of(context).backgroundGrey,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  Center(child: DappIcon(image: image, iconSize: 32)),
                  if (isEditMode && dapp is Bookmark)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () =>
                            actions!.removeBookmarkDialog(dapp, shatter!),
                        child: SvgPicture.asset(
                          Assets.svg.deleteBookmark,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!contextMenuAnimation) ...[
            const SizedBox(
              height: 8,
            ),
            Text(
              name,
              style: FontTheme.of(context)
                  .subtitle2
                  .primary()
                  .copyWith(fontWeight: FontWeight.w800),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ]
        ],
      ),
    ),
  );
}
