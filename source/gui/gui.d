module gui.gui;

import fluid;
import raylib;

import gui.pages.skolem_page;
import gui.pages.welcome_page;
import gui.pages.settings_page;
import gui.components.header;
import gui.themes;

public class Gui
{
    private Space root;
    private Page _currentPage;
    private SkolemPage _skolemPage;
    private WelcomePage _welcomePage;
    private SettingsPage _settingsPage;
    private Header _header;

    enum Page
    {
        WELCOME,
        SKOLEM,
        SETTINGS,
    }

    this()
    {
        _skolemPage = new SkolemPage(&_showSkolemPage);
        _welcomePage = new WelcomePage(&_showSkolemPage);
        _settingsPage = new SettingsPage(&_showSettingsPage);
        _header = new Header(&_showSkolemPage, &_showSettingsPage);
        
        root = _welcomePage.build();
        _currentPage = Page.WELCOME;
    }

    private void _showSkolemPage()
    {
        _currentPage = Page.SKOLEM;
        root = _buildMainFrame(_skolemPage.build());
    }

    private void _showSettingsPage()
    {
        _currentPage = Page.SETTINGS;
        root = _buildMainFrame(_settingsPage.build());
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