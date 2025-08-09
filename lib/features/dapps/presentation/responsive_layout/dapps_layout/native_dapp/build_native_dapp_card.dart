import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_presenter.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/dapp_icon.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

Widget buildNativeNativeDAppCard(
  BuildContext context,
  Dapp dapp,
  VoidCallback? onTap, {
  DAppsPagePresenter? actions,
  void Function()? shatter,
  bool animated = false,
  bool contextMenuAnimation = false,
}) {
  String? image;
  image = dapp.reviewApi?.iconV3;

  final name = dapp.app?.name;
  final url = dapp.app?.url;
  final info = dapp.app?.description;
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
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorsTheme.of(context, listen: false).backgroundGrey,
              shape: BoxShape.circle,
            ),
            child: DappIcon(
              image: image,
              iconSize: 48,
            ),
          ),
          if (!contextMenuAnimation) ...[
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? url ?? '',
                    style: FontTheme.of(context)
                        .body1
                        .primary()
                        .copyWith(fontWeight: FontWeight.bold),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    info ?? '',
                    style:
                        FontTheme.of(context).caption1.textWhite60().copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    ),
  );
}
