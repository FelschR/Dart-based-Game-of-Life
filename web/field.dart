part of game_of_life_mp;

class Field {
  HtmlElement gameEle;
  bool isMouseDown;
  bool isSimulating;
  int width;
  int height;
  List<User> userList;
  User user;

  static const String colorRed = "#FF0000";
  static const String colorBlue = "#0066FF";
  static const String colorGreen = "#009900";
  static const String colorPurple = "#9900CC";

  Map<int, Map<int, Cell>> field;
  Map<int, Map<int, Cell>> fieldUpdated;

  Field(HtmlElement gameEle, {int width: 100, int height: 100}) {
    this.gameEle = gameEle;
    this.width = width;
    this.height = height;

    CreateField();

    userList = new List<User>();
    InitializeUser();
  }

  CreateField() {
    gameEle.hidden = true;
    field = new Map<int, Map<int, Cell>>();

    for (int x = 0; x < width; x++) {
      List<Cell> cellList = new List<Cell>();
      DivElement rowDivEle = new DivElement();
      rowDivEle.classes.add("row");
      Map<int, Cell> row = new Map<int, Cell>();

      for (int y = 0; y < height; y++) {
        Cell cell = new Cell(x, y);
        String key = x.toString() + ";" + y.toString();
        row[y] = cell;
        rowDivEle.append(cell.DivEle);
      }

      field[x] = row;
      gameEle.append(rowDivEle);
    }

    gameEle.onMouseDown.listen((e) => MouseDown(e));
    gameEle.onMouseUp.listen((e) => MouseUp(e));
    gameEle.onMouseOver.listen((e) => MouseOver(e));
    gameEle.onContextMenu.listen((e) => ContextMenuOpen(e));

    gameEle.hidden = false;
  }

  InitializeUser() {
    String color = colorRed;

    for (User user in userList) {
      if (user.Color == color) {
        color = colorBlue;
      }
    }

    for (User user in userList) {
      if (user.Color == color) {
        color = colorGreen;
      }
    }

    for (User user in userList) {
      if (user.Color == color) {
        color = colorPurple;
      }
    }

    user = new User(color);
  }

  ToggleSimulation() {
    isSimulating = !isSimulating;

    if (isSimulating) {
      document.getElementsByClassName("playBt")[0].text = "Stop";
    } else {
      document.getElementsByClassName("playBt")[0].text = "Play";
    }
    Simulate();
  }

  Simulate() {
    new Timer.periodic(new Duration(milliseconds: 0), SimulateStep);
  }

  SimulateStep(Timer timer) {
    fieldUpdated = new Map<int, Map<int, Cell>>();
    field.forEach((posX, row) => row.forEach((posY, cell) => SimulateCell(cell)));
    UpdateField();

    if (!isSimulating) {
      timer.cancel();
    }
  }

  SimulateCell(Cell cell) {
    List<String> userIdAroundList = new List<String>();

    for (int xOffset = -1; xOffset < 2; xOffset++) {
      int posX = cell.posX + xOffset;
      Map<int, Cell> row = field[posX];

      for (int yOffset = -1; yOffset < 2; yOffset++) {
        if (!(xOffset == 0 && yOffset == 0)) {
          int posY = cell.posY + yOffset;
          if (row != null) {
            Cell tmpcell = row[posY];
            if (tmpcell != null && tmpcell.user != null) {
              userIdAroundList.add(tmpcell.user.id);
            }
          }
        }
      }
    }

    Cell cellUpdated = new Cell(cell.posX, cell.posY);
    cellUpdated.SetUser(cell.user);

    int userAroundLength = userIdAroundList.length;

    if ((userAroundLength == 2 && cellUpdated.user != null) || userAroundLength == 3) {
      if (cellUpdated.user == null) {
        // TODO select color / user
        cellUpdated.SetUser(user);
      }
    }
    else {
      if (cellUpdated.user != null) {
        cellUpdated.SetUser(null);
      }
    }

    int posX = cell.posX;
    int posY = cell.posY;

    if (fieldUpdated[posX] == null) {
      fieldUpdated[posX] = new Map<int, Cell>();
    }

    fieldUpdated[posX][posY] = cellUpdated;
  }

  UpdateField() {
    gameEle.hidden = true;
    field.forEach((posX, row) => row.forEach((posY, cell) => UpdateCell(posX, posY, cell)));
    gameEle.hidden = false;
  }

  UpdateCell(int posX, int posY, Cell cell) {
    User newUser = fieldUpdated[posX][posY].user;
    if (cell.user != newUser) {
      cell.SetUser(newUser);
    }
  }

  MouseDown(MouseEvent e) {
    e.preventDefault();
    isMouseDown = true;
    User newUser;
    if (e.button == 0) {
      // left click
      newUser = user;
    } else if (e.button == 2) {
      // right click
      newUser = null;
    } else {
      return;
    }

    List<String> splitList = (e.target as DivElement).id.split(";");
    int posX = int.parse(splitList.first);
    int posY = int.parse(splitList.last);

    Cell cell = field[posX][posY];
    cell.SetUser(newUser);
  }

  MouseUp(MouseEvent e) {
    isMouseDown = false;
  }

  MouseOver(MouseEvent e) {
    if (isMouseDown) {
      User newUser;
      if (e.button == 0) {
        // left click
        newUser = user;
      } else if (e.button == 2) {
        // right click
        newUser = null;
      } else {
        return;
      }

      int posX = e.client.x;
      int posY = e.client.y;
      /*
      List<String> splitList = e.target.id.split(";");
      int posX = int.parse(splitList.first);
      int posY = int.parse(splitList.last);
      */

      Cell cell = field[posX][posY];
      cell.SetUser(newUser);
    }
  }

  ContextMenuOpen(MouseEvent e) {
    e.preventDefault();
  }
}
