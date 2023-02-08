import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

//the mixin HasTappables ensures we can add tappable components
class MyGame extends FlameGame with HasTappables {
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(50.0, 50.0);

  //the paint text on the screen
  TextPaint dialogTextPainter = TextPaint(style: const TextStyle(fontSize: 30));

  bool turnAway = false;
  int dialogLevel = 0;
  int sceneLevel = 1;

//a method that is the main place where you initialize your [Game] class
  @override
  Future<void> onLoad() async {
    super.onLoad();
    const double characterSize = 200.0;

    //size is a vector that give that x,y dimension of the screen
    final screenWidth = size[0];
    final screenHeight = size[1];

    const double textBoxHeight = 80;

    //loadSprite is a Utility method to load and cache the image for a sprite based on its options.
    background2
      ..sprite = await loadSprite('background2.jpg')
      ..size = Vector2(size[0], size[1] - 100);

    background
      ..sprite = await loadSprite('background2.jpg')
      ..size = Vector2(size[0], size[1] - 100);
    add(background);

    girl
      ..sprite = await loadSprite('warrior2.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..flipHorizontally();
    add(girl);

    boy
      ..sprite = await loadSprite('warrior1.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize;
    add(boy);

    dialogButton
      ..sprite = await loadSprite('Play1.png')
      ..size = buttonSize
      ..position =
          Vector2(size[0] - buttonSize[0] - 60, size[1] - buttonSize[1] - 10);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (girl.x < size[0] / 2 + 80) {
      girl.x += 40 * dt;
      if (girl.x > 55 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 150 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    } else if (!turnAway) {
      boy.flipHorizontally();
      turnAway = true;
      if (dialogLevel == 2) {
        dialogLevel = 3;
      }
    }

    if (boy.x > size[0] / 2 - 60 && sceneLevel == 1) {
      boy.x -= 20 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (dialogLevel) {
      case 1:
        dialogTextPainter.render(
            canvas,
            'lia: Gashi, don\'t' 'go.... You\'ll die',
            Vector2(10, size[1] - 100.0));
        break;
      case 2:
        dialogTextPainter.render(
            canvas,
            'Gashi: I can\'t' ' stand and watch. I must fight for our Village',
            Vector2(10, size[1] - 100.0));
        break;
      case 3:
        dialogTextPainter.render(
            canvas, 'lia: What about our baby', Vector2(10, size[1] - 100.0));
        add(dialogButton);
        break;
      default:
    }

    switch (dialogButton.scene2Level) {
      case 1:
        //change game to scene2
        sceneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPainter.render(
            canvas, 'Gashi: child? i dont know', Vector2(10, size[1] - 100.0));
        if (turnAway) {
          boy.flipHorizontally();
          boy.x += 150;
          turnAway = false;
          //change scence occurs;
          remove(background);
          remove(girl);
          remove(boy);
          add(background2);
          add(boy);
          add(girl);
        }
        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPainter.render(
            canvas, 'lia: yes our future', Vector2(10, size[1] - 100.0));
        break;
      case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPainter.render(canvas, 'Gashi: my future will be through you',
            Vector2(10, size[1] - 100.0));
        break;
      default:
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
}
