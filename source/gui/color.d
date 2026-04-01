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

    Color paren1 = color("#00916E");
    Color paren2 = color("#FEEFE5");
    Color paren3 = color("#FFCF00");
    Color paren4 = color("#EE6123");
    Color paren5 = color("#FA003F");
}

public static Color getParenColor(int depth)
{
    switch (depth % 5) {
        case 0: return colorPalette.paren1;
        case 1: return colorPalette.paren2;
        case 2: return colorPalette.paren3;
        case 3: return colorPalette.paren4;
        case 4: return colorPalette.paren5;
        default: return colorPalette.text; // should never happen
    }
}