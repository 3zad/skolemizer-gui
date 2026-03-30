module gui.pages.skolem_page;

import fluid;
import raylib;
import std.process : browse;
import std.format;

import gui.themes;

public class SkolemPage
{
    private TextInput _skolemInput;
    private void delegate() _onRefresh;

    this(void delegate() onRefresh)
    {
        this._onRefresh = onRefresh;
    }

    public Space build()
    {
        _skolemInput = textInput(.layout!("fill"), "Formula");

        return vspace(
            .layout!"center", vframe(
                Themes.getSkolemTheme(),
                label(.layout!"center", "Unauthenticated"),
                _skolemInput,
                _buildHelpSection(),
                _buildActionButtons()
            )
        );
    }

    private Space _buildHelpSection()
    {
        return hspace(.layout!"center",
            label("Example label"),
            button(.layout!"center", "Visit help page", delegate() @trusted {
                browse("https://google.com/");
            })
        );
    }

    private Button _buildActionButtons()
    {
        return button(.layout!"center", "Save and close", delegate() @trusted {
            _onRefresh();
        });
    }

    public string getFormulaInput()
    {
        return format!"%s"(_skolemInput.value);
    }
}