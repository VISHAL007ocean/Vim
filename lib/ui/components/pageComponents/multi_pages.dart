import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:vim_mobile/ui/components/pageComponents/button.dart';
import 'package:vim_mobile/ui/components/pageComponents/content.dart';
import 'package:vim_mobile/ui/components/pageComponents/page.dart';
import 'package:vim_mobile/ui/components/pageComponents/page_view_model.dart';

class MultiPages extends StatefulWidget {
  static const String kDefaultSkipText = "BACK";
  static const String kDefaultNextText = "NEXT";
  static const String kDefaultDoneText = "DONE";

  final List<PageViewModel> pages;
  final bool showSkipButton;
  final VoidCallback onDone;
  final String skipText;
  final String nextText;
  final String doneText;

  const MultiPages({
    Key key,
    @required this.pages,
    this.showSkipButton = false,
    this.onDone,
    this.skipText = kDefaultSkipText,
    this.nextText = kDefaultNextText,
    this.doneText = kDefaultDoneText,
  })  : assert(pages != null),
        assert(onDone != null),
        assert(skipText != null),
        assert(nextText != null),
        assert(doneText != null),
        super(key: key);

  @override
  _MultiPagesState createState() => _MultiPagesState();
}

class _MultiPagesState extends State<MultiPages> {
  PageController pageController = PageController();
  int currentPage = 0;

  List<Widget> _buildPages() {
    List<Widget> pages = [];

    for (final page in widget.pages) {
      pages.add(
        MultiPage(
          bgColor: page.pageColor,
          widget: Center(child: page.image),
          content: PagesContent(
            title: page.title,
            body: page.body,
            titleStyle: page.titleTextStyle,
            bodyStyle: page.bodyTextStyle,
          ),
        ),
      );
    }

    return pages;
  }

  void _onNext() {
    var page = widget.pages[currentPage];
    if (page.validator == null || page.validator() == true) {
      final page =
          (currentPage + 1 < widget.pages.length) ? currentPage + 1 : 0;
      animateScroll(page).then((value) {
        setState(() {
          currentPage = page;
        });
      });
    }
  }

  void _onPrevious() {
    final page = (currentPage - 1 < widget.pages.length) ? currentPage - 1 : 0;
    animateScroll(page).then((value) {
      setState(() {
        currentPage = page;
      });
    });
  }

  Future<void> animateScroll(int page) {
    return pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = (currentPage == widget.pages.length - 1);
    final isFirstPage = (currentPage == 0);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: _buildPages(),
              onPageChanged: (index) {
                setState(
                  () {
                    currentPage = index;
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: (!isFirstPage && widget.showSkipButton)
                      ? Center(
                          child: PagesButton(
                            text: widget.skipText,
                            onPressed: _onPrevious,
                          ),
                        )
                      : Container(), //Change to a Container if you wish for no back button once it reaches last page
                ),
                DotsIndicator(
                  dotsCount: widget.pages.length,
                  position: currentPage.toDouble(),
                  decorator: DotsDecorator(
                    color: Colors.grey,
                    activeColor: widget.pages[currentPage].progressColor,
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: (!isLastPage)
                        ? PagesButton(
                            text: widget.nextText,
                            onPressed: _onNext,
                          )
                        : PagesButton(
                            text: widget.doneText,
                            onPressed: widget.onDone,
                          ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
