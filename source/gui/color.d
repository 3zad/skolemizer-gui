module gui.color;

import raylib;
import fluid;
import fluid.theme;

__gshared static immutable ColorPalette colorPalette = defaultPalette();

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

static ColorPalette bluePalette() pure
{
    return ColorPalette(
        color("#0D1B2A"), // background
        color("#1B263B"), // accent
        color("#FFFFFF"), // text
        color("#415A77"), // arrows
        color("#778DA9"), // conjdisj
        color("#E0E1DD"), // functions
        color("#F0F3BD"), // variables
        color("#A9BCD0"), // quantifiers
        color("#415A77"), // paren1
        color("#778DA9"), // paren2
        color("#E0E1DD"), // paren3
        color("#F0F3BD"), // paren4
        color("#A9BCD0"), // paren5
    );
}

static ColorPalette rainbowPalette() pure
{
    return ColorPalette(
        color("#282828"), // background
        color("#458588"), // accent
        color("#ebdbb2"), // text
        color("#d3869b"), // arrows
        color("#b16286"), // conjdisj
        color("#8ec07c"), // functions
        color("#fabd2f"), // variables
        color("#fe8019"), // quantifiers
        color("#458588"), // paren1
        color("#b16286"), // paren2
        color("#8ec07c"), // paren3
        color("#fabd2f"), // paren4
        color("#fe8019"), // paren5
    );
}

static ColorPalette highContrastPalette() pure
{
    // bright colors on black background.
    return ColorPalette(
        color("#000000"), // background
        color("#FF0000"), // accent
        color("#FFFFFF"), // text
        color("#00FF00"), // arrows
        color("#0000FF"), // conjdisj
        color("#FFFF00"), // functions
        color("#FF00FF"), // variables
        color("#00FFFF"), // quantifiers
        color("#FF0000"), // paren1
        color("#00FF00"), // paren2
        color("#0000FF"), // paren3
        color("#FFFF00"), // paren4
        color("#FF00FF"), // paren5
    );
}

Color getParenColor(int depth)
{
    while (depth < 0)
        depth += 5;
    final switch (depth % 5) {
        case 0: return colorPalette.paren1;
        case 1: return colorPalette.paren2;
        case 2: return colorPalette.paren3;
        case 3: return colorPalette.paren4;
        case 4: return colorPalette.paren5;
    }
}