module gui.skolem_view;

import fluid;
import raylib;

import std.stdio;
import std.conv;
import std.format;
import std.typecons;
import std.process : spawnProcess;
import core.stdc.stdlib : exit;
import std.file : thisExePath;
import std.process : browse;

import fluid.theme;

public struct SkolemView
{
    public Theme skolemTheme() {
    return Theme(
        rule!GridRow(margin = 100),
            rule!Button(
                // typeface = minecraftFont,
                backgroundColor = Colors.DARKGRAY,
                textColor = Colors.WHITE,
                margin = 10,
                padding = 5,
            ),

            rule!Frame(
                backgroundColor = Colors.DARKGRAY,
            ),
            rule!Label(
                padding = 15,
                // typeface = minecraftFont,
                textColor = Colors.WHITE,
            ),
            rule!TextInput(
                textColor = Colors.WHITE,
                backgroundColor = Colors.DARKGRAY,
                // typeface = minecraftFont
            ),
    );
    }

    @system
    public Space skolemView(void delegate() refresh)
    {
        auto skolemInput = textInput(.layout!("fill"), "Fomula");

        return vspace(
                .layout!"center", vframe(
                    skolemTheme(),
                    label(.layout!"center", "Unauthenticated"),
                    skolemInput,
                    hspace(.layout!"center",
                        label("Example label"),
                        button(.layout!"center", "Visit help page", delegate() @trusted {
                            browse("https://google.com/");
                        })
                    ),
                    button(.layout!"center", "Save and close", delegate() @trusted {
                        refresh();
                    }))
        );
    }
}
