module gui.font;

import fluid;
import fluid.typeface;
import fluid.theme;
import raylib;

__gshared Typeface mathFont;

static this() {
    mathFont = Style.loadTypeface("./source/resources/fonts/NotoSansMath-Regular.ttf");
}