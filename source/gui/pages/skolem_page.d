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
            
                .layout!"center",
            vframe(
                Themes.getSkolemTheme(),
                _buildInputSection(),
                _buildSymbolBar(),
                _buildDivider(),
                _buildNormalFormSection(),
                _buildHornSection(),
                _buildSatSection(),
                _skolemizedLabelSpace,
        )
        );
    }

    private Theme _sectionLabelTheme()
    {
        return Theme(
            rule!Label(
                textColor = colorPalette.text,
                typeface = mathFont,
                margin = 4,
        ),
        );
    }

    private Theme _primaryButtonTheme()
    {
        return Theme(
            rule!Button(
                backgroundColor = colorPalette.accent,
                textColor = colorPalette.text,
                margin = 5,
                padding = 10,
        ),
        );
    }

    private Theme _secondaryButtonTheme()
    {
        return Theme(
            rule!Button(
                backgroundColor = colorPalette.accent,
                textColor = colorPalette.text,
                margin = 5,
                padding = 8,
        ),
        );
    }

    private Theme _symbolButtonTheme(Color symbolColor)
    {
        return Theme(
            rule!Button(
                backgroundColor = colorPalette.accent,
                textColor = symbolColor,
                margin = 3,
                padding = 8,
                typeface = mathFont,
        ),
        );
    }

    private Space _buildInputSection()
    {
        return vspace(
            
                .layout!"fill",
            label(_sectionLabelTheme(), "——— Formula ———"),
            _skolemInput,
        );
    }

    private Space _buildSymbolBar()
    {
        return hspace(
            
                .layout!"center",
            button(_symbolButtonTheme(colorPalette.quantifiers), "∀", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "∀";
            }),
            button(_symbolButtonTheme(colorPalette.quantifiers), "∃", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "∃";
            }),
            button(_symbolButtonTheme(colorPalette.conjdisj), "∧", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "∧";
            }),
            button(_symbolButtonTheme(colorPalette.conjdisj), "∨", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "∨";
            }),
            button(_symbolButtonTheme(colorPalette.arrows), "⟶", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "⟶";
            }),
            button(_symbolButtonTheme(colorPalette.arrows), "⟷", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "⟷";
            }),
            button(_symbolButtonTheme(colorPalette.text), "¬", delegate() @trusted {
                _skolemInput.value = _skolemInput.value ~ "¬";
            }),
        );
    }

    private Space _buildDivider()
    {
        return hspace(
            
                .layout!"center",
            label(
                Theme(rule!Label(
                textColor = colorPalette.conjdisj,
                typeface = mathFont,
                margin = 8,
                )),
            "· · · · · · · · · · · · · · · · · · · · · ·"
        ),
        );
    }

    private Space _buildNormalFormSection()
    {
        return vspace(
            
                .layout!"fill",
            label(_sectionLabelTheme(), "——— Normal Forms ———"),
            hspace(
                
                .layout!"center",
                button(_primaryButtonTheme(), "Skolem Normal Form", delegate() @trusted {
                    _showResult(_computeSkolemNF());
                }),
                button(_secondaryButtonTheme(), "Conjunctive Normal Form", delegate() @trusted {
                    _showResult(_computeCNF());
                }),
        ),
        );
    }

    private Space _buildHornSection()
    {
        return vspace(
            
                .layout!"fill",
            label(_sectionLabelTheme(), "——— Horn Clauses ———"),
            hspace(
                
                .layout!"center",
                button(_secondaryButtonTheme(), "Check Horn", delegate() @trusted {
                    string input = getFormulaInput();
                    bool isHorn = checkHornClause(input);
                    dstring msg = isHorn
                    ? "Horn formula"d : "Not a Horn formula"d;
                    _showResult(msg);
                }),
                button(_secondaryButtonTheme(), "Convert to Horn", delegate() @trusted {
                    dstring result;
                    try
                    {
                        string input = getFormulaInput();
                        result = toSetString(tryHornConvert(toDisjunctForm(input)));
                    }
                    catch (Error e)
                    {
                        result = "Error: "d ~ to!dstring(e.msg);
                    }
                    catch (Exception e)
                    {
                        result = "Exception: "d ~ to!dstring(e.msg);
                    }
                    _showResult(result);
                    writeln("Hornified formula: ", result);
                }),
        ),
        );
    }

    private Space _buildSatSection()
    {
        return vspace(
            
                .layout!"fill",
            label(_sectionLabelTheme(), "——— Satisfiability ———"),
            hspace(
                
                .layout!"center",
                button(_secondaryButtonTheme(), "Truth Table", delegate() @trusted {
                    try
                    {
                        string input = getFormulaInput();
                        auto disj = toDisjunctForm(parseFormula(input));
                        foreach (key, value; disj)
                        {
                            foreach (clause; value)
                            {
                                if (clause.type == NodeType.Predicate)
                                {
                                    _showResult(
                                    "Error: Formula contains predicates — truth table unavailable."d);
                                    return;
                                }
                            }
                        }
                        auto isSat = naiveSAT(disj);
                        dstring msg = isSat == SatResult.Satisfiable
                        ? "Satisfiable  (truth table)"d : "Unsatisfiable  (truth table)"d;
                        _showResult(msg);
                    }
                    catch (Error e)
                    {
                        _showResult("Error: "d ~ to!dstring(e.msg));
                    }
                    catch (Exception e)
                    {
                        _showResult("Exception: "d ~ to!dstring(e.msg));
                    }
                }),
                button(_secondaryButtonTheme(), "SLD Resolution", delegate() @trusted {
                    try
                    {
                        string input = getFormulaInput();
                        auto isSat = SLDResolve(toDisjunctForm(parseFormula(input)));
                        dstring msg = isSat == SatResult.Satisfiable
                        ? "Satisfiable  (SLD resolution)"d
                        : "Unsatisfiable  (SLD resolution)"d;
                        _showResult(msg);
                    }
                    catch (Error e)
                    {
                        _showResult("Error: "d ~ to!dstring(e.msg));
                    }
                    catch (Exception e)
                    {
                        _showResult("Exception: "d ~ to!dstring(e.msg));
                    }
                }),
        ),
        );
    }

    private void _showResult(dstring text)
    {
        auto coloredOutput = _buildColoredLabel(text);
        _skolemizedLabelSpace.children = coloredOutput.children;
        _skolemizedLabelSpace.updateSize();
    }

    private dstring _computeSkolemNF()
    {
        dstring result;
        try
        {
            string input = getFormulaInput();
            result = toFormulaString(skolemizeFormula(input));
            result = _cleanDoubleNegation(result);
            result = _digitToSubscript(result);
            writeln("Skolemized formula: ", result);
        }
        catch (Error e)
        {
            result = "Error: "d ~ to!dstring(e.msg);
        }
        catch (Exception e)
        {
            result = "Exception: "d ~ to!dstring(e.msg);
        }
        return result;
    }

    private dstring _computeCNF()
    {
        dstring result;
        try
        {
            string input = getFormulaInput();
            result = toFormulaString(distribute(skolemizeFormula(input)));
            result = _cleanDoubleNegation(result);
            result = _digitToSubscript(result);
            writeln("CNF formula: ", result);
        }
        catch (Error e)
        {
            result = "Error: "d ~ to!dstring(e.msg);
        }
        catch (Exception e)
        {
            result = "Exception: "d ~ to!dstring(e.msg);
        }
        return result;
    }

    private dstring _cleanDoubleNegation(dstring s)
    {
        while (s.canFind("¬ ¬"d) || s.canFind("¬¬"d))
        {
            s = s.replace("¬ ¬", "");
            s = s.replace("¬¬", "");
        }
        return s;
    }

    private dstring _digitToSubscript(dstring s)
    {
        dchar[] subscript = "₀₁₂₃₄₅₆₇₈₉".array;
        dstring digits = "0123456789"d;
        foreach (i, c; digits)
            s = s.replace(c, subscript[i]);
        return s;
    }

    private Space _buildColoredLabel(dstring text)
    {
        auto container = vspace();
        auto currentLine = hspace();
        container.children ~= currentLine;

        int parenDepth = 0;
        int lineCharCount = 0;
        const int maxCharsPerLine = GetScreenWidth() / 16;

        foreach (dchar c; text)
        {
            Color uColor;
            bool isSymbol = false;

            switch (c)
            {
            case '∧':
            case '∨':
            case '&':
            case '|':
                isSymbol = true;
                uColor = colorPalette.conjdisj;
                break;
            case '∀':
            case '∃':
                isSymbol = true;
                uColor = colorPalette.quantifiers;
                break;
            case '⟶':
            case '⟷':
                isSymbol = true;
                uColor = colorPalette.arrows;
                break;
            default:
                if (c >= 'a' && c <= 'z')
                    uColor = colorPalette.variables;
                else if (c >= 'A' && c <= 'Z')
                    uColor = colorPalette.functions;
                else if (c == '(')
                {
                    uColor = getParenColor(parenDepth);
                    parenDepth++;
                }
                else if (c == ')')
                {
                    uColor = getParenColor(parenDepth - 1);
                    parenDepth--;
                }
                else
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

            if (lineCharCount >= maxCharsPerLine - lineCharCount * 0.2 && isSymbol)
            {
                currentLine = hspace();
                container.children ~= currentLine;
                lineCharCount = 0;
            }
        }

        return container;
    }

    public string getFormulaInput()
    {
        return format("%s", _skolemInput.value);
    }
}
