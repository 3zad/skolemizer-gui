module gui.gui;

import fluid;
import raylib;

import gui.pages.skolem_page;
import gui.pages.welcome_page;
import gui.components.header;
import gui.themes;

public class Gui
{
    private Space root;
    private Page _currentPage;
    private SkolemPage _skolemPage;
    private WelcomePage _welcomePage;
    private Header _header;

    enum Page
    {
        WELCOME,
        SKOLEM,
    }

    this()
    {
        _skolemPage = new SkolemPage(&_showSkolemPage);
        _welcomePage = new WelcomePage(&_showSkolemPage);
        _header = new Header(&_showSkolemPage, &_onButton2Click);
        
        root = _welcomePage.build();
        _currentPage = Page.WELCOME;
    }

    private void _showSkolemPage()
    {
        _currentPage = Page.SKOLEM;
        root = _buildMainFrame(_skolemPage.build());
    }

    private void _onButton2Click()
    {
        // nothing
    }

    private Space _buildMainFrame(Space contentArea)
    {
        return vspace(.layout!("fill"), Themes.getHeaderTheme(),
            _header.build(),
            hseparator(),
            hspace(.layout!("fill"),
                vspace(.layout!(5, "fill"),
                    contentArea
                ),
            )
        );
    }

    public void draw()
    {
        root.draw();
    }
}