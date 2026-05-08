module gui.pages.settings_page;

import fluid;
import fluid.popup_button;
import raylib;
import std.stdio;

import gui.themes;
import gui.color;

public class SettingsPage
{
    private void delegate() _refresh;

    this(void delegate() refresh)
    {
        this._refresh = refresh;
    }

    public Space build()
    {
        return vspace(
            .layout!"center", vframe(
                Themes.getIntroTheme(),
                label(.layout!"center", "Settings"),
                _buildDropdown(),
            )
        );
    }

    public Space _buildDropdown()
    {
        ButtonImpl!(Label)[] buttons;

        static foreach (i, palette; colorPalettes)
        {
            buttons ~= button(palette.name, delegate() @trusted {
                colorPalette = colorPalettes[i];
                _refresh();
            });
        }

        return hspace(
            popupButton("Color palette", vspace(buttons))
        );
    }
}