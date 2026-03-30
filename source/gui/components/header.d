module gui.components.header;

import fluid;
import raylib;
import fluid.theme;

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
                backgroundColor = Colors.DARKGRAY,
                textColor = Colors.WHITE,
            ),
            rule!Label(
                textColor = Colors.WHITE,
            ),
            rule!IntInput(
                textColor = Colors.WHITE,
            ),
            rule!CodeInput(
                textColor = Colors.WHITE,
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