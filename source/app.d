import std.stdio;

import skolemizer;
import raylib;
import fluid;

import gui.gui;
import gui.color;

void main()
{
    // Enable UTF-8 output on Windows
    version(Windows) {
        import core.sys.windows.windows : SetConsoleCP, SetConsoleOutputCP;
        SetConsoleCP(65001); // UTF-8 input
        SetConsoleOutputCP(65001); // UTF-8 output
    }

	SetTraceLogLevel(7);
	SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);
	SetConfigFlags(ConfigFlags.FLAG_WINDOW_ALWAYS_RUN);
	InitWindow(800, 800, "Skolemizer");
	SetTargetFPS(30);
	scope (exit) CloseWindow();

	auto gui = new Gui();

	while (!WindowShouldClose)
	{
		BeginDrawing();

		ClearBackground(colorPalette.background);

		gui.draw();

		EndDrawing();
	}
}
