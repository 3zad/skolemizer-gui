module gui.color;

import raylib;
import fluid;
import fluid.theme;

__gshared static immutable ColorPalette colorPalette = ColorPalette();

private static struct ColorPalette
{
    Color background = color("#1e1e1e");
    Color accent = color("#0D2C54");
    Color text = color("#FFFFFF");
    Color arrows = color("#7FB800");
    Color conjdisj = color("#F6511D");
    Color functions = color("#FFB400");
    Color variables = color("#00A6ED");
    Color quantifiers = color("#9B2335");
}