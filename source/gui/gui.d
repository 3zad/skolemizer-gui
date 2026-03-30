module gui.gui;

import fluid;
import raylib;

import fluid.theme;

import gui.skolem_view;

public class Gui
{
    private Space root, current_page, skolem_page;

    private SkolemView skolemView;

    this()
    {
        this.skolemView = SkolemView();

        auto intro_theme = Theme(
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
                // typeface = minecraftFont,
                textColor = Colors.WHITE,
            )
        );

        auto welcome_page = vspace(
            
                .layout!"center", vframe(
                intro_theme,
                label(.layout!"center", "Skolemizer"),
                label(.layout!"center", "Build v" ~ "1.0.0"),
                button(.layout!"center", "Continue", delegate() @trusted {
                    root = mainFrame(current_page);
                }))
        );

    
        skolem_page = skolemView.skolemView(&refreshSkolemView);
        
        current_page = skolem_page;
        root = welcome_page;

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
                // // typeface = minecraftFont
            ),
            rule!Label(
                textColor = Colors.WHITE,
                // // typeface = minecraftFont
            ),
            rule!IntInput(
                textColor = Colors.WHITE,
                // typeface = minecraftFont
            ),
            rule!CodeInput(
                textColor = Colors.WHITE,
                // typeface = minecraftFont
            ),
        );
    }

    void refreshSkolemView()
    {
        root = mainFrame(skolemView.skolemView(&refreshSkolemView));
    }

    private Space mainFrame(Space _current_page)
    {
        return vspace(.layout!("fill"),headerTheme(),
            hspace(
                button("Skolem", delegate() @trusted {
                    root = mainFrame(skolemView.skolemView(&refreshSkolemView));
                }),
                button("Button2", delegate() @trusted {
                    // nothing
                }),
            ),
            hseparator(),
            hspace(.layout!("fill"),
                vseparator(),
                vspace(.layout!(5, "fill"),
                    _current_page
                ),
            )
            
        );
    }

    public void draw()
    {
        root.draw();
    }
}
