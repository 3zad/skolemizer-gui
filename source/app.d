import std.stdio;

import skolemizer;
import raylib;
import fluid;

import gui.gui;

void main()
{
	SetTraceLogLevel(7);
	SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);
	SetConfigFlags(ConfigFlags.FLAG_WINDOW_ALWAYS_RUN);
	InitWindow(400, 400, "Skolemizer");
	SetTargetFPS(30);
	scope (exit) CloseWindow();


	string fomula = "AxEy(P(x) & Q(y))";
	auto skolemized = skolemizeFormula(fomula);
	writeln("Original formula: ", fomula);
	writeln("Skolemized formula: ", toFormulaString(skolemized));

	auto gui = new Gui();

	while (!WindowShouldClose)
	{
		BeginDrawing();

		ClearBackground(Colors.DARKGRAY);

		gui.draw();

		EndDrawing();
	}
}
