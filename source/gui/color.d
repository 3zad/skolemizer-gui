module gui.color;

import raylib;
import fluid;
import fluid.theme;

__gshared static immutable ColorPalette colorPalette = pinkPalette();

static struct ColorPalette
{
    Color background;
    Color accent;
    Color text;
    Color arrows;
    Color conjdisj;
    Color functions;
    Color variables;
    Color quantifiers;

    Color paren1;
    Color paren2;
    Color paren3;
    Color paren4;
    Color paren5;
}

static ColorPalette defaultPalette() pure
{
    return ColorPalette(
        color("#1e1e1e"), // background
        color("#0D2C54"), // accent
        color("#FFFFFF"), // text
        color("#7FB800"), // arrows
        color("#F6511D"), // conjdisj
        color("#FFB400"), // functions
        color("#00A6ED"), // variables
        color("#9B2335"), // quantifiers
        color("#00916E"), // paren1
        color("#FEEFE5"), // paren2
        color("#FFCF00"), // paren3
        color("#EE6123"), // paren4
        color("#FA003F"), // paren5
    );
}

static ColorPalette pinkPalette() pure
{
    return ColorPalette(
        color("#200108"), // background
        color("#510415"), // accent
        color("#FFFFFF"), // text
        color("#B33791"), // arrows
        color("#C562AF"), // conjdisj
        color("#DB8DD0"), // functions
        color("#FEC5F6"), // variables
        color("#fee7fb"), // quantifiers
        color("#B33791"), // paren1
        color("#C562AF"), // paren2
        color("#DB8DD0"), // paren3
        color("#FEC5F6"), // paren4
        color("#fee7fb"), // paren5
    );
}

Color getParenColor(int depth)
{
    final switch (depth % 5) {
        case 0: return colorPalette.paren1;
        case 1: return colorPalette.paren2;
        case 2: return colorPalette.paren3;
        case 3: return colorPalette.paren4;
        case 4: return colorPalette.paren5;
    }
}