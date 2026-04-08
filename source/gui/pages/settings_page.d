module gui.pages.settings_page;

import fluid;
import fluid.popup_button;
import raylib;

import gui.themes;

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
        return hspace(
            popupButton("Color palette",
                label("Are you sure? This action cannot be undone."),
                hspace(
                    .layout!"end",
                    button("Cancel", delegate() @trusted {
                        this._refresh();
                    }),
                    button("Clear", delegate() @trusted {
                        this._refresh();
                    }),
                ),
            ),
        );
    }
}