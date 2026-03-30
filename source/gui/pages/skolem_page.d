module gui.pages.skolem_page;

import fluid;
import raylib;
import skolemizer;
import std.process : browse;
import std.format;
import std.stdio;
import std.conv;
import std.array;
import std.string;
import clipboard;

import gui.themes;

public class SkolemPage
{
    private TextInput _skolemInput;
    private Label _skolemizedLabel;
    private void delegate() _onRefresh;

    this(void delegate() onRefresh)
    {
        this._onRefresh = onRefresh;
    }

    public Space build()
    {
        _skolemInput = textInput(.layout!("fill"), "Formula");
        _skolemizedLabel = label(.layout!"center", "");

        return vspace(
            .layout!"center", vframe(
                Themes.getSkolemTheme(),
                _skolemInput,
                _buildSpecialCharButtons(),
                _buildHelpSection(),
                _buildActionButtons(),
                _skolemizedLabel
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
        return button(.layout!"center", "Skolemize", delegate() @trusted {
            string input = getFormulaInput();
            input = input.replace("∀", "A").replace("∃", "E")
                                           .replace("∧", "&")
                                           .replace("∨", "|")
                                           .replace("→", "->")
                                           .replace("¬", "!");
            dstring skolemized = toFormulaString(skolemizeFormula(input));
            skolemized = skolemized.replace("and", "∧")
                                   .replace("or", "∨")
                                   .replace("not", "¬");
            dchar[] subscript = "₀₁₂₃₄₅₆₇₈₉".array;
            dstring digits = "0123456789"d;  // Note the 'd' suffix for dstring

            foreach (i, c; digits)
            {
                skolemized = skolemized.replace(c, subscript[i]);
            }
            _skolemizedLabel.text = to!string(skolemized);
            writeln("Skolemized formula: ", _skolemizedLabel.text);
            // ∀x(P(x) → ∃y(Q(x,y) ∧ ¬R(y))) - correct
            // ∀x∃y∀z∃w(P(s(x)) → (P(y)∧P(w) → ¬P(s(z))))) - wrong answer
            // 
        });
    }

    private Space _buildSpecialCharButtons()
    {
        return hspace(
            button("∀", delegate() @trusted {
                pushToClipboard("∀");
            }),
            button("∃", delegate() @trusted {
                pushToClipboard("∃");
            }),
            button("∧", delegate() @trusted {
                pushToClipboard("∧");
            }),
            button("∨", delegate() @trusted {
                pushToClipboard("∨");
            }),
            button("→", delegate() @trusted {
                pushToClipboard("→");
            }),
            button("¬", delegate() @trusted {
                pushToClipboard("¬");
            })
        );
    }

    public string getFormulaInput()
    {
        return format("%s", _skolemInput.value);
    }
}