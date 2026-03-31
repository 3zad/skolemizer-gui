module gui.components.header;

import fluid;
import raylib;
import fluid.theme;

import gui.color;

public class Header
{
    private Theme _headerTheme;
    private void delegate() _onSkolemClick;
    private void delegate() _onButton2Click;

    this(void delegate() onSkolemClick, void delegate() onButton2Click)
    {
        this._onSkolemClick = onSkolemClick;
        this._onButton2Click = onButton2Click;
        this._headerTheme = headerTheme();
    }

    private Theme headerTheme()
    {
        return Theme(
            rule!GridRow(margin = 100),
            rule!Button(
                margin = 10,
                padding = 10,
                backgroundColor = colorPalette.accent,
                textColor = colorPalette.text,
            ),
            rule!Label(
                textColor = colorPalette.text,
            ),
            rule!IntInput(
                textColor = colorPalette.text,
            ),
            rule!CodeInput(
                textColor = colorPalette.text,
                backgroundColor = colorPalette.background,
            ),
        );
    }

    public Space build()
    {
        return hspace(_headerTheme,
            button("Skolem", delegate() @trusted {
                _onSkolemClick();
            }),
            button("Button2", delegate() @trusted {
                _onButton2Click();
            }),
        );
    }
}