import 'package:flutter/material.dart';
import 'package:moonchain_wallet/features/dapps/presentation/dapps_presenter.dart';
import 'package:moonchain_wallet/features/dapps/presentation/responsive_layout/dapps_layout/dapp_icon.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

Widget buildPartnerDAppCard(
  BuildContext context,
  Dapp dapp,
  VoidCallback? onTap,
  bool horizontallyExpanded, {
  DAppsPagePresenter? actions,
}) {
  String? image;
  image = dapp.reviewApi?.iconV3;

  final name = dapp.app?.name;
  final url = dapp.app?.url;
  final info = dapp.app?.description;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 190),
      decoration: BoxDecoration(
        color: ColorsTheme.of(context).backgroundGrey,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name ?? url ?? '',
                style: FontTheme.of(context)
                    .body1
                    .primary()
                    .copyWith(fontWeight: FontWeight.w500),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: ColorsTheme.of(context, listen: false).black,
                  shape: BoxShape.circle,
                ),
                child: DappIcon(
                  image: image,
                  iconSize: 40,
                ),
              ),
            ],
          ),
          horizontallyExpanded
              ? const Spacer()
              : const SizedBox(
                  height: Sizes.spaceSmall,
                ),
          Row(
            children: [
              Flexible(
                child: Text(
                  info ?? '',
                  style: FontTheme.of(context).caption1.white().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: horizontallyExpanded ? 1 : 2,
                ),
              ),
              if (horizontallyExpanded)
                const SizedBox(
                  width: 40,
                )
            ],
          ),
        ],
      ),
    ),
  );
}
