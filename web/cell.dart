part of game_of_life_mp;

class Cell {
  int posX;
  int posY;
  DivElement divEle;
  User user = null;

  get DivEle => divEle;

  static const String alive = "alive";
  static const String aliveRed = "aliveRed";
  static const String aliveBlue = "aliveBlue";
  static const String aliveGreen = "aliveGreen";
  static const String alivePurple = "alivePurple";

  Cell(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
    divEle = new DivElement();

    divEle.id = posX.toString() + ";" + posY.toString();
    divEle.classes.add("cell");
  }

  SetUser(User user) {
    if (this.user != user && user != null) {
      this.user = user;
      divEle.classes.add("alive");
      String color;
      if (user.Color == Field.colorRed) {
        color = aliveRed;
      } else if (user.Color == Field.colorBlue) {
        color = aliveBlue;
      } else if (user.Color == Field.colorGreen) {
        color = aliveGreen;
      } else if (user.Color == Field.colorPurple) {
        color = alivePurple;
      }
      divEle.classes.add(color);
    } else if (this.user != user) {
      String prevColor = null;
      if (this.user != null) {
        prevColor = this.user.Color;
      }
      this.user = null;
      divEle.classes.remove(alive);
      if (prevColor == Field.colorRed) {
        divEle.classes.remove(aliveRed);
      } else if (prevColor == Field.colorBlue) {
        divEle.classes.remove(aliveBlue);
      } else if (prevColor == Field.colorGreen) {
        divEle.classes.remove(aliveGreen);
      } else if (prevColor == Field.colorPurple) {
        divEle.classes.remove(alivePurple);
      }
    }
  }
}
