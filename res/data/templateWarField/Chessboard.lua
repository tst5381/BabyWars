return {
  warFieldName = "Chessboard",
  playersCount = 2,

  width = 11,
  height = 11,
  layers = {
    {
      type = "tilelayer",
      name = "TileBase",
      x = 0,
      y = 0,
      width = 11,
      height = 11,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        19, 43, 23, 43, 43, 43, 43, 43, 23, 43, 22,
        34, 1, 51, 1, 1, 1, 1, 1, 51, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 38,
        34, 1, 60, 1, 1, 1, 1, 1, 60, 1, 38,
        20, 52, 28, 52, 52, 52, 52, 52, 28, 52, 26
      }
    },
    {
      type = "tilelayer",
      name = "TileObject",
      x = 0,
      y = 0,
      width = 11,
      height = 11,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 117, 142, 127, 122, 112, 122, 127, 142, 117, 0,
        0, 78, 137, 99, 0, 99, 0, 99, 132, 78, 0,
        0, 78, 99, 0, 99, 0, 99, 0, 99, 78, 0,
        0, 78, 100, 100, 100, 100, 100, 100, 100, 78, 0,
        0, 78, 99, 0, 99, 0, 99, 0, 99, 78, 0,
        0, 78, 100, 100, 100, 100, 100, 100, 100, 78, 0,
        0, 78, 99, 0, 99, 0, 99, 0, 99, 78, 0,
        0, 78, 131, 99, 0, 99, 0, 99, 136, 78, 0,
        0, 116, 141, 126, 121, 111, 121, 126, 141, 116, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Unit",
      x = 0,
      y = 0,
      width = 11,
      height = 11,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 164, 252, 0, 0, 0, 0, 0, 252, 164, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 156, 156, 156, 156, 156, 156, 156, 156, 156, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 155, 155, 155, 155, 155, 155, 155, 155, 155, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 163, 251, 0, 0, 0, 0, 0, 251, 163, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
