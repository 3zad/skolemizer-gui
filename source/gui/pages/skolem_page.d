module gui.pages.skolem_page;

import fluid;
import fluid.theme;
import raylib;
import skolemizer;
import std.format;
import std.stdio;
import std.conv;
import std.array;
import std.string;
import clipboard;
import std.algorithm.searching;

import gui.themes;
import gui.color;
import gui.font;

public class SkolemPage
{
    private CodeInput _skolemInput;
    private Space _skolemizedLabelSpace;
    private void delegate() _onRefresh;

    this(void delegate() onRefresh)
    {
        this._onRefresh = onRefresh;
    }

    public Space build()
    {
        _skolemInput = codeInput(.layout!("fill"));
        _skolemizedLabelSpace = vspace(.layout!"center");

        return vspace(
            .layout!"center", vframe(
                Themes.getSkolemTheme(),
                _skolemInput,
                _buildSpecialCharButtons(),
                _buildActionButtons(),
                _skolemizedLabelSpace
            )
        );
    }

    private Button _buildActionButtons()
    {
        return button(.layout!"center", "Skolemize", delegate() @trusted {

            dstring skolemized;
            try {
                string input = getFormulaInput();
                skolemized = toFormulaString(skolemizeFormula(input));

                writeln(skolemized);


                while (skolemized.canFind("¬ ¬"d) || skolemized.canFind("¬¬"d)) {
                    skolemized = skolemized.replace("¬ ¬", ""); // double negation.
                    skolemized = skolemized.replace("¬¬", ""); // double negation.
                }
                dchar[] subscript = "₀₁₂₃₄₅₆₇₈₉".array;
                dstring digits = "0123456789"d;

                foreach (i, c; digits)
                {
                    skolemized = skolemized.replace(c, subscript[i]);
                }

                foreach (i, c; digits)
                {
                    skolemized = skolemized.replace(c, subscript[i]);
                }

            } catch (Error e) {
                skolemized = "Error: "d ~ to!dstring(e.msg);
            } catch (Exception e) {
                skolemized = "Exception: "d ~ to!dstring(e.msg);
            }


            auto coloredOutput = _buildColoredLabel(skolemized);
            _skolemizedLabelSpace.children = coloredOutput.children;
            _skolemizedLabelSpace.updateSize();
            
            // debug print
            writeln("Skolemized formula: ", skolemized);
            // ∀x(P(x) ⟶ ∃y(Q(x,y) ∧ ¬R(y))) - correct
            // ∀x∃y∀z∃w(P(s(x)) ⟶ (P(y)∧P(w) ⟶ ¬P(s(z))))) - correct
            // ∀x(P(x)⟷R(x)) - correct
            // ∀x((P(x) ⟶ R(x)) ∧ (R(x) ⟶ P(x))) - correct
            // ∀x(P(x) ⟷ Q(x) ⟷ R(x) ⟷ ¬S(x) ⟷ ¬P(x)) - idk yet
            // ∀xP(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(x))))))))))))))))))) - correct
            // ∀x∃y∀z∃w∀v∃u(P(x,y) ∧ Q(z,w) ⟶ R(v,u) ∧ S(x,z,v))
        });
    }

    private Space _buildColoredLabel(dstring skolemized)
    {
        auto container = vspace();
        auto currentLine = hspace();
        container.children ~= currentLine;

        int parenDepth = 0;
        int lineCharCount = 0;
        const int maxCharsPerLine = GetScreenWidth()/16; // rough estimate based on font size

        foreach (dchar c; skolemized) {
            Color uColor;
            bool isSymbol = false;

            switch (c) {
                case '∧': 
                case '∨':
                case '&':
                case '|':
                    isSymbol = true;
                    uColor = colorPalette.conjdisj;
                    break;
                case '∀': case '∃':
                    isSymbol = true;
                    uColor = colorPalette.quantifiers;
                    break;
                case '⟶': case '⟷':
                    isSymbol = true;
                    uColor = colorPalette.arrows;
                    break;
                default:
                    if (c >= 'a' && c <= 'z')
                        uColor = colorPalette.variables;
                    else if (c >= 'A' && c <= 'Z')
                        uColor = colorPalette.functions;
                    else if (c == '(') {
                        uColor = getParenColor(parenDepth);
                        parenDepth++;
                    } else if (c == ')') {
                        uColor = getParenColor(parenDepth - 1);
                        parenDepth--;
                    } else
                        uColor = colorPalette.text;
            }

            auto labelTheme = Theme(
                rule!Label(
                    textColor = uColor,
                    typeface = mathFont,
                ),
            );

            currentLine.children ~= labelTheme.label(format("%c", c));
            lineCharCount++;

            if (lineCharCount >= maxCharsPerLine - lineCharCount * 0.2 && isSymbol) {
                // newline
                currentLine = hspace();
                container.children ~= currentLine;
                lineCharCount = 0;
            }
        }

        return container;
    }

    private Space _buildSpecialCharButtons()
    {
        auto customColor(Color hex) {
            return Theme(
                rule!Button(
                    backgroundColor = colorPalette.accent,
                    textColor = hex,
                    margin = 10,
                    padding = 5,
                    typeface = mathFont,
                ),
            );
        }

        return hspace(
            button(customColor(colorPalette.quantifiers), "∀", delegate() @trusted {
                // append "∀" to the current input
                _skolemInput.value = _skolemInput.value ~ "∀";

            }),
            button(customColor(colorPalette.quantifiers), "∃", delegate() @trusted {
                // append "∃" to the current input
                _skolemInput.value = _skolemInput.value ~ "∃";
            }),
            button(customColor(colorPalette.conjdisj), "∧", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "∧";
            }),
            button(customColor(colorPalette.conjdisj), "∨", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "∨";
            }),
            button(customColor(colorPalette.arrows), "⟶", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "⟶";
            }),
            button(customColor(colorPalette.arrows), "⟷", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "⟷";
            }),
            button(customColor(colorPalette.text), "¬", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "¬";
            })
        );
    }

    public string getFormulaInput()
    {
        return format("%s", _skolemInput.value);
    }
}