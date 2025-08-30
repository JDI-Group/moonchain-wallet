import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonchain_wallet/features/ai_chat/presentation/chat_presenter.dart';
import 'package:mxc_ui/mxc_ui.dart';

class TypingMarkdown extends StatefulWidget {
  final String data;
  final Duration charDelay;
  final Color textColor;
  final ChatPresenter chatPresenter;
  final bool shouldAnimate;
  final bool replay;

  const TypingMarkdown({
    Key? key,
    required this.data,
    Duration? charDelay,
    required this.textColor,
    required this.chatPresenter,
    required this.shouldAnimate,
    required this.replay,
  })  : charDelay = charDelay ?? const Duration(milliseconds: 40),
        super(key: key);

  @override
  _TypingMarkdownState createState() => _TypingMarkdownState();
}

class _TypingMarkdownState extends State<TypingMarkdown> {
  String _visibleText = '';
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.shouldAnimate) {
      _startTyping();
    } else {
      showFullText();
    }
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.charDelay, (timer) {
      if (_currentIndex < widget.data.length) {
        setState(() {
          _visibleText += widget.data[_currentIndex];
          _currentIndex++;
        });
      } else {
        if (widget.replay) {
          reset();
        } else {
          _timer?.cancel();
        }
      }
    });
  }

  void reset() {
    _currentIndex = 0;
    _visibleText = '';
  }

  void replay() {
    _startTyping();
  }

  void finishAnimation() {
    // Do not act If It's replaying
    if (widget.replay) {
      return;
    }

    if (_currentIndex == widget.data.length - 1) {
      return;
    }
    setState(() {
      showFullText();
      _currentIndex = widget.data.length - 1;
    });
    _timer?.cancel();
  }

  void showFullText() {
    _visibleText += widget.data.substring(_currentIndex);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: finishAnimation,
      child: MarkdownBody(
        data: _visibleText,
        selectable: false,
        // styleSheetTheme: MarkdownStyleSheetBaseTheme.material.,
        shrinkWrap: true,
        // padding: EdgeInsets.zero,
        onTapLink: (text, href, title) async {
          if (href != null) {
            widget.chatPresenter.launchUrl(href);
          }
        },
        sizedImageBuilder: (config) {
          final path = config.uri.toString();

          // Handle local SVG
          if (path.endsWith(".svg")) {
            return CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: path.contains('https')
                  ? SvgPicture.network(path)
                  : SvgPicture.asset(path),
            );
          }

          // Handle normal PNG/JPG assets
          if (path.startsWith("assets/")) {
            return CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(path),
              backgroundColor: Colors.transparent,
            );
          }

          // Handle network images
          return CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(path),
            backgroundColor: Colors.transparent,
          );
        },
        styleSheet: MarkdownStyleSheet(
          h1: FontTheme.of(context).body1().copyWith(
                color: widget.textColor,
              ),
          p: FontTheme.of(context).body1().copyWith(
                color: widget.textColor,
              ),
          // tableCellsDecoration: BoxDecoration(
          //   color: Colors.grey[100], // background of each cell
          //   border:
          //       Border.all(color: Colors.grey), // cell borders

          // ),
          tableCellsPadding: const EdgeInsets.all(Sizes.space2XSmall),
          tableHead: FontTheme.of(context).caption2().copyWith(
                color: widget.textColor,
                fontWeight: FontWeight.w700,
              ),
          tableBody: FontTheme.of(context).caption2().copyWith(
                color: widget.textColor,
              ),
        ),
      ),
    );
  }
}
