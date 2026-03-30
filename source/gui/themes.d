module gui.themes;

import fluid;
import raylib;
import fluid.theme;

import gui.font : mathFont;

public static class Themes
{
    public static Theme getSkolemTheme()
    {
        return Theme(
            rule!GridRow(margin = 100),
            rule!Button(
                backgroundColor = Colors.GRAY,
                textColor = Colors.WHITE,
                margin = 10,
                padding = 5,
                typeface = mathFont,
            ),
            rule!Frame(
                backgroundColor = Colors.DARKGRAY,
                typeface = mathFont,
            ),
            rule!Label(
                padding = 15,
                textColor = Colors.WHITE,
                typeface = mathFont,
            ),
            rule!TextInput(
                textColor = Colors.WHITE,
                backgroundColor = Colors.DARKGRAY,
                typeface = mathFont,
            ),
        );
    }

    public static Theme getHeaderTheme()
    {
        return Theme(
            rule!GridRow(margin = 100),
            rule!Button(
                margin = 10,
                padding = 10,
                backgroundColor = Colors.GRAY,
                textColor = Colors.WHITE,
                typeface = mathFont,

            ),
            rule!Label(
                textColor = Colors.WHITE,
                typeface = mathFont,
            ),
            rule!IntInput(
                textColor = Colors.WHITE,
                typeface = mathFont,
            ),
            rule!CodeInput(
                textColor = Colors.WHITE,
                typeface = mathFont,
            ),
        );
    }

    public static Theme getIntroTheme()
    {
        return Theme(
            rule!GridRow(margin = 100),
            rule!Button(
                backgroundColor = Colors.GRAY,
                textColor = Colors.WHITE,
                margin = 10,
                padding = 5,
                typeface = mathFont,
            ),
            rule!Frame(
                backgroundColor = Colors.DARKGRAY,
                typeface = mathFont,
            ),
            rule!Label(
                textColor = Colors.WHITE,
                typeface = mathFont,
            )
        );
    }
}