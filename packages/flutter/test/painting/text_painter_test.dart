// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TextPainter caret test', () {
    final TextPainter painter = new TextPainter()
      ..textDirection = TextDirection.ltr;

    String text = 'A';
    painter.text = new TextSpan(text: text);
    painter.layout();

    Offset caretOffset = painter.getOffsetForCaret(const ui.TextPosition(offset: 0), ui.Rect.zero);
    expect(caretOffset.dx, 0);
    caretOffset = painter.getOffsetForCaret(new ui.TextPosition(offset: text.length), ui.Rect.zero);
    expect(caretOffset.dx, painter.width);

    // Check that getOffsetForCaret handles a character that is encoded as a surrogate pair.
    text = 'A\u{1F600}';
    painter.text = new TextSpan(text: text);
    painter.layout();
    caretOffset = painter.getOffsetForCaret(new ui.TextPosition(offset: text.length), ui.Rect.zero);
    expect(caretOffset.dx, painter.width);
  });

  test('TextPainter error test', () {
    final TextPainter painter = new TextPainter(textDirection: TextDirection.ltr);
    expect(() { painter.paint(null, Offset.zero); }, throwsFlutterError);
  });

  test('TextPainter requires textDirection', () {
    final TextPainter painter1 = new TextPainter(text: const TextSpan(text: ''));
    expect(() { painter1.layout(); }, throwsAssertionError);
    final TextPainter painter2 = new TextPainter(text: const TextSpan(text: ''), textDirection: TextDirection.rtl);
    expect(() { painter2.layout(); }, isNot(throwsException));
  });

  test('TextPainter size test', () {
    final TextPainter painter = new TextPainter(
      text: const TextSpan(
        text: 'X',
        style: const TextStyle(
          inherit: false,
          fontFamily: 'Ahem',
          fontSize: 123.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    expect(painter.size, const Size(123.0, 123.0));
  });

  test('TextPainter textScaleFactor test', () {
    final TextPainter painter = new TextPainter(
      text: const TextSpan(
        text: 'X',
        style: const TextStyle(
          inherit: false,
          fontFamily: 'Ahem',
          fontSize: 10.0,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaleFactor: 2.0,
    );
    painter.layout();
    expect(painter.size, const Size(20.0, 20.0));
  });

  test('TextPainter default text height is 14 pixels', () {
    final TextPainter painter = new TextPainter(
      text: const TextSpan(text: 'x'),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    expect(painter.preferredLineHeight, 14.0);
    expect(painter.size, const Size(14.0, 14.0));
  });

  test('TextPainter sets paragraph size from root', () {
    final TextPainter painter = new TextPainter(
      text: const TextSpan(text: 'x', style: const TextStyle(fontSize: 100.0)),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    expect(painter.preferredLineHeight, 100.0);
    expect(painter.size, const Size(100.0, 100.0));
  });
}
