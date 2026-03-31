module gui.themes;

import fluid;
import raylib;
import fluid.theme;
import gui.color;

import gui.font : mathFont;

public static class Themes
{
    public static Theme getSkolemTheme()
    {
        return Theme(
            rule!GridRow(margin = 100),
            rule!Button(
                backgroundColor = colorPalette.background,
                textColor = colorPalette.text,
                margin = 10,
                padding = 5,
                typeface = mathFont,
            ),
            rule!Frame(
                backgroundColor = colorPalette.background,
                typeface = mathFont,
            ),
            rule!Label(
                padding = 15,
                textColor = colorPalette.text,
                typeface = mathFont,
            ),
            rule!TextInput(
                textColor = colorPalette.text,
                backgroundColor = colorPalette.background,
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
                backgroundColor = colorPalette.background,
                textColor = colorPalette.text,
                typeface = mathFont,

            ),
            rule!Label(
                textColor = colorPalette.text,
                typeface = mathFont,
            ),
            rule!IntInput(
                textColor = colorPalette.text,
                typeface = mathFont,
            ),
            rule!CodeInput(
                textColor = colorPalette.text,
                typeface = mathFont,
            ),
        );
    }

    public static Theme getIntroTheme()
    {
        return Theme(
            rule!GridRow(margin = 100),
            rule!Button(
                backgroundColor = colorPalette.background,
                textColor = colorPalette.text,
                margin = 10,
                padding = 5,
                typeface = mathFont,
            ),
            rule!Frame(
                backgroundColor = colorPalette.background,
                typeface = mathFont,
            ),
            rule!Label(
                textColor = colorPalette.text,
                typeface = mathFont,
            ),
            rule!ImageView(
                margin = 20,
            ),
        );
    }
}