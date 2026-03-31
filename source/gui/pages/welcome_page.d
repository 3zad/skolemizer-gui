module gui.pages.welcome_page;

import fluid;
import raylib;

import gui.themes;

public class WelcomePage
{
    private void delegate() _onContinue;

    this(void delegate() onContinue)
    {
        this._onContinue = onContinue;
    }

    public Space build()
    {
        return vspace(
            .layout!"center", vframe(
                Themes.getIntroTheme(),
                label(.layout!"center", "Skolemizer"),
                _buildImage(),
                label(.layout!"center", "Build v" ~ "1.0.0"),
                button(.layout!"center", "Continue", delegate() @trusted {
                    _onContinue();
                })
            )
        );
    }

    private ImageView _buildImage()
    {
        ImageView welcomeImage = imageView(.layout!"center", "./source/resources/images/skolemizerlogo.png",
                    Vector2(200, 200));
        return welcomeImage;

    }
}