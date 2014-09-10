import "dart:html";
import "dart:async";
import "User.dart";

class Square {
  int posX;
  int posY;
  DivElement divEle;
  User user = null;

  get DivEle => divEle;

  Square(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
    divEle = new DivElement();

    divEle.id = posX.toString() + ";" + posY.toString();
    divEle.classes.add("square");
  }

  SetUser(User user) {
    if (this.user != user && user != null) {
      this.user = user;
      UpdateColor(user.Color);
    } else {
      this.user = null;
      UpdateColor("#ffffff");
    }
  }

  UpdateColor(String color) {
    divEle.style.background = color;
  }
}
